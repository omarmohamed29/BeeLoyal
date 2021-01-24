import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loyalbee/models/DataBase.dart';
import '../models/CartItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Order.dart';
import 'package:http/http.dart' as http;



class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  OrderItem findById(String id) {
    return _orders.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchOrders() async {
    final _userData = await DBProvider.db.getUsers();

    final newUser= Map<String , String >.from(_userData);

    final token = newUser['token'];
    final uid = newUser['userId'];


    final url =
        'https://beel-6e17a.firebaseio.com/orders/$uid.json?auth=$token';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        datetime: DateTime.parse(orderData['dateTime']),
        location: orderData['location'],
        status: orderData['status'],
        phoneNumber: orderData['phoneNumber'],
        city: orderData['city'],
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total,
      String location, String phoneNumber, String city) async {
    final prefs = await SharedPreferences.getInstance();
    final prefUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = prefUserData['token'];
    final uid = prefUserData['userId'];
    final url =
        'https://beel-6e17a.firebaseio.com/orders/$uid.json?auth=$token';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'location': location,
        'status': false,
        'phoneNumber': phoneNumber,
        'city': city,
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
        0,
        OrderItem(
            id: jsonDecode(response.body)['name'],
            amount: total,
            products: cartProducts,
            datetime: timestamp));
    notifyListeners();
  }
}
