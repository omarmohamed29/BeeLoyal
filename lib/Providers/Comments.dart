import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Analysis.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Comment.dart';

class Comments with ChangeNotifier {
  List<Comment> _comments = [];

  List<Comment> get comments {
    return [..._comments];
  }

  List<Analysis> _analysis = [];

  Future<String> sentimentAnalysis(String body) async {
    final secondUrl = 'https://apis.paralleldots.com/v4/sentiment';
    final apiKey = 'n5OIuCYHM7S743BDgxjUZYRgudkxWwnexIAYC5iqZtw';
    try {
      final response = await http.post(secondUrl, body: {
        'text': body,
        'api_key': apiKey,
      });
      final reviews = json.decode(response.body) as Map<String, dynamic>;
      final List<Analysis> retrievedReviews = [];
      reviews.forEach((reviewId, reviewBody) {
        retrievedReviews.add(Analysis(
            positive: reviewBody['positive'],
            negative: reviewBody['negative'],
            neutral: reviewBody['neutral']));
      });
      _analysis = retrievedReviews.toList();
      if (_analysis[0].positive > _analysis[0].negative) {
        return "+" + _analysis[0].positive.toString();
      } else {
        return "-" + _analysis[0].negative.toString();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addComment(String name, String email, String body, String prodId,
      String emotion) async {

    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];

    final url =
        'https://beel-6e17a.firebaseio.com/Comments/$prodId.json?auth=$token';
    try {
      http.post(url,
          body: jsonEncode({
            'name': name,
            'email': email,
            'body': body,
            'emotion': emotion,
          }));
    } catch (error) {
      throw error;
    }
  }

  Future<void> retrieveComment(String prodId) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];

    final url =
        'https://beel-6e17a.firebaseio.com/Comments/$prodId.json?auth=$token';
    try {
      final response = await http.get(url);
      // print(jsonDecode(response.body));
      final allComments = json.decode(response.body) as Map<String, dynamic>;
      final List<Comment> retrievedComments = [];

      allComments.forEach((commentId, commentBody) {
        retrievedComments.add(Comment(
          id: commentId,
          name: commentBody['name'],
          email: commentBody['email'],
          body: commentBody['body'],
          emotion: commentBody['emotion'],
        ));
      });
      _comments = retrievedComments.toList();
      // print(_comments[0].email);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
