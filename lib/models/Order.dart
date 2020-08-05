import 'package:flutter/material.dart';
import 'CartItem.dart';

class OrderItem {
  final String id;

  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  final String location;
  final String phoneNumber;
  final String city;
  bool newItem;
  bool status;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.datetime,
    this.location,
    this.city,
    this.phoneNumber,
    this.newItem = true,
    this.status,
  });
}