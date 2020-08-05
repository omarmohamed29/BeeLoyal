import 'package:flutter/material.dart';

class Wallet with ChangeNotifier {
  final String id;

  int points;
  int money;

  Wallet({this.id, this.points, this.money});

  //getter and setter
  int get point {
    return points;
  }

  set point(int value) {
    this.points = value;
  }

  int get moneyData {
    return money;
  }

  set moneyData(int value) {
    this.money = value;
  }

  //end getter and setter


}
