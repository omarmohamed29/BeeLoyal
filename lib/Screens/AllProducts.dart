import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Screens/SearchScreen.dart';
import '../widgets/ProductCard.dart';
import 'package:provider/provider.dart';
import '../Providers/Products.dart';
import '../widgets/CategoriesViewer.dart';

enum FilterOptions {
  Favourites,
  All,
}

class AllProducts extends StatefulWidget {

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  String result = "";
  Future _productsFuture;
  var showAll = true;
  var _showOnlyFavourite = false;

  @override
  void initState() {
    _productsFuture = getProducts();
    super.initState();
  }

  getProducts() async {
    return Provider.of<Products>(context, listen: false).fetchProducts();
  }

  Future<String> refresh() async {
    setState(() {
      _productsFuture = getProducts();
    });

    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Products",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat-Bold",
                fontSize: 30,
                color:Theme.of(context).textTheme.headline2.color,),
          ),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.search , color:Theme.of(context).iconTheme.color),
                onPressed: () async {
                 await showSearch(
                      context: context, delegate: ProductSearch());
                },
              ),
            ),
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    _showOnlyFavourite = true;
                  } else {
                    _showOnlyFavourite = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
                color:Theme.of(context).iconTheme.color,
                size: 25,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('only Favourites'),
                  value: FilterOptions.Favourites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                )
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: Color(0xFFFFCB5F),
            dragStartBehavior: DragStartBehavior.start,
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "All",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
              Tab(
                child: Text(
                  "Men",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
              Tab(
                child: Text(
                  "Women",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
              Tab(
                child: Text(
                  "Children",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
              Tab(
                child: Text(
                  "Wallets",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
              Tab(
                child: Text(
                  "Watches",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: refresh,
              color: Color(0xFFFFCB5F),
              child: FutureBuilder(
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
                        return ProductsGrid(_showOnlyFavourite, showAll);
                      }
                    }
                    return Container(
                      child: Center(child: Text('Please login again')),
                    );
                  }),
            ),
            RefreshIndicator(
              onRefresh: refresh,
              color: Color(0xFFFFCB5F),
              child: FutureBuilder(
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
                        return CategoriesViewer("Men", _showOnlyFavourite);
                      }
                    }
                    return Container(
                      child: Center(child: Text('Please login again')),
                    );
                  }),
            ),
            RefreshIndicator(
              onRefresh: refresh,
              color: Color(0xFFFFCB5F),
              child: FutureBuilder(
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
                        return CategoriesViewer("Women", _showOnlyFavourite);
                      }
                    }
                    return Container(
                      child: Center(child: Text('Please login again')),
                    );
                  }),
            ),
            RefreshIndicator(
              onRefresh: refresh,
              color: Color(0xFFFFCB5F),
              child: FutureBuilder(
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
                        return CategoriesViewer("Children", _showOnlyFavourite);
                      }
                    }
                    return Container(
                      child: Center(child: Text('Please login again')),
                    );
                  }),
            ),
            RefreshIndicator(
              onRefresh: refresh,
              color: Color(0xFFFFCB5F),
              child: FutureBuilder(
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
                        return CategoriesViewer("Wallets", _showOnlyFavourite);
                      }
                    }
                    return Container(
                      child: Center(child: Text('Please login again')),
                    );
                  }),
            ),
            RefreshIndicator(
              onRefresh: refresh,
              color: Color(0xFFFFCB5F),
              child: FutureBuilder(
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
                        return CategoriesViewer("Watches", _showOnlyFavourite);
                      }
                    }
                    return Container(
                      child: Center(child: Text('Please login again')),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
