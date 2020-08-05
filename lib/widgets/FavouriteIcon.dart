import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Product.dart';

class FavIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final  product = Provider.of<Product>(context , listen: false);
    return Consumer<Product>(
      builder: (context, product, child) => IconButton(
        icon: Icon(
          product.isFavourite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
          size: 25,
        ),
        onPressed: () {
          product.toggleFavouriteStatus();
        },
      ),
    );
  }
}
