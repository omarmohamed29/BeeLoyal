import 'package:flutter/material.dart';

class Message with  ChangeNotifier{
  final String id ;
  final String  content;
  final String title;

  Message({this.id ,this.content ,this.title});
}