import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:loyalbee/models/AuthUser.dart';
import 'package:loyalbee/models/DataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyAMwLNufLFn0d1MH8IemW3gfy_6NJnYqIg';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
    var newUser = UserAuth(email: email , password: password, token: _token , expiryDate: _expiryDate.toIso8601String() , userId: _userId);
    DBProvider.db.newUser(newUser);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin() async {
    final _userData = await DBProvider.db.getUsers() ;
    Map<String , String> newUser = {};
    if(!newUser.containsKey('token') && _userData != null ){
      newUser= Map<String , String >.from(_userData);
    }
    else return false;

    final expiryDate = DateTime.parse(newUser['expiryDate']);
    print("exp = " + expiryDate.toString());
    if (expiryDate.isBefore(DateTime.now()) || expiryDate == null) {
      return false;
    }

    _token = newUser['token'];
    _userId = newUser['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    await DBProvider.db.dropTable(userId);
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
