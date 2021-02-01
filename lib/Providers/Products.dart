import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Sizes.dart';
import 'package:flutter/material.dart';
import '../models/Product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  Future<void> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final userId = prefUserData['userId'];
    final token = prefUserData['token'];

    final url = 'https://beel-6e17a.firebaseio.com/Products.json?auth=$token';
    try {
      final uid = userId;
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final favUrl =
          'https://beel-6e17a.firebaseio.com/userFavourites/$uid.json?auth=$token';
      final favouriteResponse = await http.get(favUrl);
      final favouriteData = jsonDecode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['Description'],
          price: double.parse(prodData['price']),
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
          imageUrl: prodData['ImageUrl'],
          color: prodData['color'],
          brand: prodData['brand'],
          category: prodData['category'],
          subCategory: prodData['subCategory'],
          hits: prodData['hits'],
          inStock: prodData['inStock'],
          sizes: (prodData['sizes'] as List<dynamic>)
              .map(
                (item) => Sizes(
                    small: item['small'],
                    medium: item['medium'],
                    large: item['large'],
                    xLarge: item['xLarge']),
              )
              .toList(),
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }


  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProd(
      String prodId,
      String title,
      String description,
      double price,
      String imageUrl,
      String color,
      String brand,
      String category,
      String subCategory,
      int hits,
      int inStock) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];

    try {
      final url =
          'https://beel-6e17a.firebaseio.com/Products/$prodId.json?auth=$token';

      await http.patch(url,
          body: jsonEncode({
            'title': title,
            'Description': description,
            'price': price.toString(),
            'ImageUrl': imageUrl,
            'color': color,
            'brand': brand,
            'category': category,
            'subCategory': subCategory,
            'hits': hits,
            'inStock': inStock,
          }));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> removeFavouriteStatus(bool status , String id) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];
    final uid = prefUserData['userId'];
    notifyListeners();
    final url =
        'https://beel-6e17a.firebaseio.com/userFavourites/$uid/$id.json?auth=$token';
    try {
      await http.put(url, body: jsonEncode(status));
    } catch (error) {
      notifyListeners();
    }

    notifyListeners();
  }
}
