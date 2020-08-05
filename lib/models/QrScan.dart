import 'package:flutter/material.dart';

class QrScanner with ChangeNotifier {
  final DateTime date;

  int points;

  QrScanner({this.date, this.points});

  int get point {
    return points;
  }

  set point(int value) {
    this.points = value;
  }
}