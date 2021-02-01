import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loyalbee/models/Sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


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
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final uid = prefUserData['userId'];
    final token = prefUserData['token'];

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
