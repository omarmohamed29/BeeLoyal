import 'package:flutter/material.dart';
import 'package:loyalbee/models/DataBase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/QrScan.dart';


class GetPoints with ChangeNotifier {
  List<QrScanner> _qrs = [];

  List<QrScanner> get qrs {
    return [..._qrs];
  }

  Future<void> scanForPoints(int points) async {
    final _userData = await DBProvider.db.getUsers();

    final newUser= Map<String , String >.from(_userData);

    final token = newUser['token'];
    final uid = newUser['userId'];

    final timestamp = DateTime.now();
    final url =
        'https://beel-6e17a.firebaseio.com/ScannerHistory/$uid.json?auth=$token';

    try {
      await http.post(url,
          body: jsonEncode({
            'dateTime': timestamp.toIso8601String(),
            'points': points,
          }));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> retrieveQrs() async {
    final _userData = await DBProvider.db.getUsers();

    final newUser= Map<String , String >.from(_userData);

    final token = newUser['token'];
    final uid = newUser['userId'];


    try {
      final url =
          'https://beel-6e17a.firebaseio.com/ScannerHistory/$uid.json?auth=$token';

      final response = await http.get(url);
      final extractedWallet = jsonDecode(response.body) as Map<String, dynamic>;
      final List<QrScanner> qrData = [];

      extractedWallet.forEach((qrId, qrInsider) {
        qrData.add(QrScanner(
        date: DateTime.parse(qrInsider['dateTime']),
          points: qrInsider['points']
        ));
      });
      _qrs = qrData.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updatePoints(int money , String id , int points) async {
    final _userData = await DBProvider.db.getUsers();

    final newUser= Map<String , String >.from(_userData);

    final token = newUser['token'];
    final uid = newUser['userId'];

    try {
      final url =
          'https://beel-6e17a.firebaseio.com/Wallet/$uid/$id.json?auth=$token';

      await http.put(url,
          body: jsonEncode({
            'id': uid,
            'points': points,
            'money' : money
          }));

    } catch (error) {
      throw (error);
    }
  }
}
