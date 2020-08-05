import 'package:flutter/material.dart';
import '../Providers/Products.dart';
import 'package:provider/provider.dart';

import 'ProductItem.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavs;
  final bool showAll;

  ProductsGrid(this.showFavs , this.showAll);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
    final products =
        widget.showFavs ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      itemCount: widget.showAll ? products.length : 4 ,
      itemBuilder: (ctx , i) =>ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(products[i].id),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4/5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
