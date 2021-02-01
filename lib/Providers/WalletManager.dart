import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/Wallet.dart';

class WalletManager with ChangeNotifier {
  List<Wallet> _wallet = [];

  List<Wallet> get wallet {
    return [..._wallet];
  }

  //walletConverter
  Future<void> pointsConverter(int point, int money) async {
    wallet[0].points -= point;
    wallet[0].money += money;
    notifyListeners();
  }

  Future<void> purchase(int total) async {
    wallet[0].money -= total;
    notifyListeners();
  }

  Future<void> voucherMoney(int points)async {
    wallet[0].points -= points;
    notifyListeners();
  }

  Future<void> addToWallet(int money, int points) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final uid = prefUserData['userId'];
    final token = prefUserData['token'];


    final url =
        'https://beel-6e17a.firebaseio.com/Wallet/$uid.json?auth=$token';

    await http.post(url,
        body: jsonEncode({
          'id': uid,
          'points': points,
          'money': money,
        }));
  }

  Future<void> retrieveWallet() async {

    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final uid = prefUserData['userId'];
    final token = prefUserData['token'];
    try {
      final url =
          'https://beel-6e17a.firebaseio.com/Wallet/$uid.json?auth=$token';

      final response = await http.get(url);
//      print(response.body);
      final extractedWallet = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Wallet> walletData = [];
      extractedWallet.forEach((walletId, walletInsider) {
        walletData.add(Wallet(
            id: walletId,
            points: walletInsider['points'],
            money: walletInsider['money']));
      });
      // print(response.body);
      _wallet = walletData.toList();
      notifyListeners();
    } catch (error){
      throw (error);
    }
  }

  Future<void> updateWallet(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final uid = prefUserData['userId'];
    final token = prefUserData['token'];


    try {
      final url =
          'https://beel-6e17a.firebaseio.com/Wallet/$uid/$id.json?auth=$token';

      await http.put(url,
          body: jsonEncode({
            'id': uid,
            'points': wallet[0].points,
            'money': wallet[0].money,
          }));
    } catch (error) {
      throw (error);
    }
  }
}
