import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/Offer.dart';


class Offers with ChangeNotifier{

  List<Offer> _offers = [
  ];

  List<Offer> get offers {
    return [..._offers];
  }


  Future<void> retrieveOffer() async{
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];
    final uid = prefUserData['userId'];
    final url = 'https://beel-6e17a.firebaseio.com/offers.json?auth=$token';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Offer> offerInformation = [];

      extractedData.forEach((offerId , offerData){
        offerInformation.add(Offer(
            id:  offerId ,
            title: offerData['title'],
            description: offerData['description'],
            amount: offerData['amount'],
            dueDate:  DateTime.parse(offerData['dueDate'])
        ));

      });
      _offers = offerInformation.reversed.toList();
      notifyListeners();
    }catch(error){
      throw(error);
    }
  }

  double offerCalculate(double price){
    double afterDiscount = price - (price * (_offers[0].amount / 100));
    return afterDiscount;
  }
}