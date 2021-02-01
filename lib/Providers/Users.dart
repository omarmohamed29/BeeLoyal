import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Users with ChangeNotifier {
  List<User> _users = [
  ];

  Future<void>addUser(String name , String address , String  email , String city , String phoneNumber) async{
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final uid = prefUserData['userId'];
    final token = prefUserData['token'];

    final url = 'https://beel-6e17a.firebaseio.com/Users/$uid.json?auth=$token';
     await http.post(
      url , body: jsonEncode({
      'name' : name ,
      'address' : address,
      'email' : email,
       'city' : city,
       'phoneNumber' : phoneNumber,
    }),
    );
  }


   Future<void>editUser(String name , String address , String id , String city , String phoneNumber) async{
     final prefs = await SharedPreferences.getInstance();
     final prefUserData =
     json.decode(prefs.getString('userData')) as Map<String, Object>;
     final uid = prefUserData['userId'];
     final token = prefUserData['token'];
    final url = 'https://beel-6e17a.firebaseio.com/Users/$uid/$id.json?auth=$token';
     await http.patch(
      url , body: jsonEncode({
      'name' : name ,
      'address' : address,
       'city':city,
       'phoneNumber' : phoneNumber,
    }),
    );
  }

  Future<void> retrieveUser() async{
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final userId = prefUserData['userId'];
    final token = prefUserData['token'];

    final url = 'https://beel-6e17a.firebaseio.com/Users/$userId.json?auth=$token';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<User> userInformation = [];

      extractedData.forEach((userId , userData){
        userInformation.add(User(
          id:  userId ,
          address: userData['address'],
          name: userData['name'],
          email: userData['email'],
            city: userData['city'],
          phoneNumber:userData['phoneNumber'],
        ));

      });
      _users = userInformation.toList();
      notifyListeners();
    }catch(error){
    }
  }

  List<User> get users {
    return [..._users];
  }
}
