import 'package:flutter/cupertino.dart';

class User with ChangeNotifier{
  final String name ;
  final String id;
  String address;
  final String email ;
  final String city;
  final String phoneNumber;

  User({
    this.name ,
    this.id,
    this.address,
    this.email,
    this.city,
    this.phoneNumber,
});

}