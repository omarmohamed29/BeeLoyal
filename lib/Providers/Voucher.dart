import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Voucher with ChangeNotifier {
  final bool status;
  final String id;
  final int points;
  final String userName;
  final DateTime expiryDate ;

  Voucher({this.status, this.id, this.points, this.userName , this.expiryDate});
}


class Vouchers with ChangeNotifier {

  List<Voucher> _vouchers=[];

  List<Voucher> get vouchers {
    return [..._vouchers];
  }



  Future<void>addVoucher(bool status, int points , String userName ) async{
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final uid = prefUserData['userId'];
    final token = prefUserData['token'];

    final url = 'https://beel-6e17a.firebaseio.com/Vouchers/$uid.json?auth=$token';
    final expiryDate = DateTime.now().add(Duration(days: 7));
    final response = await http.post(
      url , body: jsonEncode({
      'status' : status ,
      'points' : points,
      'expiryDate' : expiryDate.toIso8601String(),
      'userName' : userName,
    }),
    );

    _vouchers.insert(0, Voucher(
      id: jsonDecode(response.body)['name'],
      status: status,
      points: points,
      expiryDate: expiryDate,
      userName: userName
    ));
  }

  Future<void> retrieveVoucher() async{
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final uid = prefUserData['userId'];
    final token = prefUserData['token'];

    final url = 'https://beel-6e17a.firebaseio.com/Vouchers/$uid.json?auth=$token';

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Voucher> voucherInformation = [];

      extractedData.forEach((voucherId , voucherData){
        voucherInformation.add(Voucher(
            id: voucherId ,
            status: voucherData['status'],
            userName: voucherData['userName'],
            expiryDate:DateTime.parse(voucherData['expiryDate']) ,
            points: voucherData['points'],
        ));

      });
      _vouchers = voucherInformation.toList();
      notifyListeners();
   
  }

}
