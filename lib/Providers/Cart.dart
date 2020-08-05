import 'package:flutter/material.dart';

import '../models/CartItem.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalCash {
    var total = 0.0;
    _items.forEach((key, cartItem){
      {
        total += cartItem.price * cartItem.quantity;
      }
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String prodId, double price, String title, String image) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price,
              image: existingCartItem.image));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1,
              image: image));
    }
    notifyListeners();
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
          image: existingCartItem.image,
        ),
      );
    } else {
      _items.remove(productId);
      notifyListeners();
    }
  }
  void clear() {
    _items = {};
    notifyListeners();
  }
}
