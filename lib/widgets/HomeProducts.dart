import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'ProductCard.dart';
import 'package:provider/provider.dart';
import '../Providers/Products.dart';

class HomeProducts extends StatefulWidget {
  @override
  _HomeProductsState createState() => _HomeProductsState();
}

class _HomeProductsState extends State<HomeProducts> with AutomaticKeepAliveClientMixin<HomeProducts> {
  var _showOnlyFavourite = false;
  Future _productsFuture;


  @override
  void initState() {
    _productsFuture = getProducts();
    super.initState();
  }

  getProducts() async {
    return Provider.of<Products>(context, listen: false).fetchProducts();
  }
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        FutureBuilder(
            future: _productsFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                    child: SpinKitWave(
                      color: Colors.amberAccent,
                      type: SpinKitWaveType.start,
                      size: 15,
                    ));
              } else {
                if (dataSnapshot.error != null) {
                  Center(
                    child: Text('An error occured'),
                  );
                } else {
                  return ProductsGrid(_showOnlyFavourite , false);
                }
              }
              return Container(
                child: Center(child: Text('Please login again')),
              );
            }),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
