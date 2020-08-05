import 'package:flutter/material.dart';

class Comment with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String body;
  final String emotion;

  Comment(
      {this.id, this.name, this.email, this.body, this.emotion});
}
