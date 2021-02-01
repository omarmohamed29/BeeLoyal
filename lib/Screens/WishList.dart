import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Products.dart';

class WishList extends StatefulWidget {
  static const routeName = '/wishList';

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Future _productsFuture;

  getProducts() async {
    return await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  void initState() {
    _productsFuture = getProducts();
    super.initState();
  }

  Future<String> refresh() async {
    setState(() {
      _productsFuture = getProducts();
    });

    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
    final products = productsData.favouriteItems;
    return RefreshIndicator(
      onRefresh: refresh,
      color: Color(0xFFFFCB5F),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40, left: 10),
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        alignment: Alignment.topLeft,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).textTheme.headline2.color,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0, left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'My',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Bold",
                          fontSize: 40,
                          color:  Color(0xFFFFCB5F)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 125.0, left: 70),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'WishList',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Light",
                          fontSize: 30,
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: products.length,
              itemBuilder: (ctx, i) => Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(products[i].imageUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(
                      products[i].title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Bold",
                          fontSize: 15,
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                    subtitle: Text(
                      'price : ' + products[i].price.toString(),
                      style: TextStyle(
                          fontFamily: "Montserrat-Light",
                          fontSize: 13,
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                    trailing: FlatButton(
                      child: Text(
                        "Remove",
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontSize: 13,
                            color: Colors.red.withOpacity(0.6)),
                      ),
                      onPressed: () {
                        Provider.of<Products>(context, listen: false)
                            .removeFavouriteStatus(
                                bool.fromEnvironment("false"), products[i].id);
                        refresh();
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
