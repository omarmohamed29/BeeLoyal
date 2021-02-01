import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Rate.dart';

class Rating with ChangeNotifier{
  List<Rate> _rating = [];

  List<Rate> get rating {
    return [..._rating];
  }

  double average(){
    var result = _rating.map((m) => double.parse(m.rate)).reduce((a, b) => a + b) / _rating.length;
    return result;
  }

  double total(double rateAm){
    var result = _rating.where((e) => double.parse(e.rate) == rateAm).toList().length.toDouble();
    if(result == null){
      result = 1;
    }
    return result;
  }



  Future<void> addRate(String rating , String prodId) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];

    final url =
        'https://beel-6e17a.firebaseio.com/Rate/$prodId.json?auth=$token';
    try {
      http.post(url,
          body: jsonEncode({
            'rating': rating
          }));
    } catch (error) {
      throw error;
    }
  }

  Future<void> retrieveRate(String prodId) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];

    final url =
        'https://beel-6e17a.firebaseio.com/Rate/$prodId.json?auth=$token';
    try {
      final response = await http.get(url);
      final allRating = json.decode(response.body) as Map<String, dynamic>;
      final List<Rate> retrievedRate = [];
      allRating.forEach((ratetId, rateBody) {
        retrievedRate.add(Rate(
          id: ratetId,
          rate: rateBody['rating'],
        ));
      });
      _rating = retrievedRate.toList();
      print("received ");
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}