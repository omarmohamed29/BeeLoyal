import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loyalbee/models/Sizes.dart';
import 'dart:convert';

import 'DataBase.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String color;
  final String category;
  final String subCategory;
  final String brand;
  final int inStock;
  final int hits;
  final List<Sizes> sizes ;
  bool isFavourite;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.color,
    this.category,
    this.subCategory,
    this.brand,
    this.hits,
    this.inStock,
    this.sizes,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    final _userData = await DBProvider.db.getUsers();

    final newUser= Map<String , String >.from(_userData);

    final token = newUser['token'];
    final uid = newUser['userId'];

    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://beel-6e17a.firebaseio.com/userFavourites/$uid/$id.json?auth=$token';
    try {
      final response = await http.put(url, body: jsonEncode(isFavourite));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
