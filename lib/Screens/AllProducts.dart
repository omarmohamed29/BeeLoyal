import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'ProductDetails.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Products",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat-Bold",
                fontSize: 30,
                color: Color(0xFF3F3C36)),
          ),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  final Products result = await showSearch(
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
                color: Colors.black54,
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
                      color: Color(0xFF3F3C36)),
                ),
              ),
              Tab(
                child: Text(
                  "Men",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
                ),
              ),
              Tab(
                child: Text(
                  "Women",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
                ),
              ),
              Tab(
                child: Text(
                  "Children",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
                ),
              ),
              Tab(
                child: Text(
                  "Wallets",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
                ),
              ),
              Tab(
                child: Text(
                  "Watches",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
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

class ProductSearch extends SearchDelegate<Products> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productsName = Provider.of<Products>(context, listen: false);
    final result = productsName.items
        .where((prodItem) => prodItem.title.toLowerCase().contains(query))
        .toList();
    return FutureBuilder(
      future: Provider.of<Products>(context, listen: false).fetchProducts(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(200),
            child: Center(
                child: SpinKitCircle(
              color: Color(0xFFFFCB5F),
              size: 12,
            )),
          );
        } else {
          if (dataSnapshot.error != null) {
            Center(
              child: Text('An error occured'),
            );
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: result.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: NetworkImage(result[i].imageUrl),
                              fit: BoxFit.cover)),
                    ),
                    title: Text(result[i].title),
                    trailing: Text(result[i].price.toString() + " EGP"),
                    onTap: () {
                      close(context, productsName);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProductDetails(result[i].id)));
                    },
                  );
                });
          }
        }
        return Center(
          child: Text("I have no products"),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productsName = Provider.of<Products>(context, listen: false);
    final result = productsName.items
        .where((prodItem) => prodItem.title.toLowerCase().contains(query))
        .toList();
    return FutureBuilder(
      future: Provider.of<Products>(context, listen: false).fetchProducts(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(200),
            child: Center(
                child: SpinKitCircle(
              color: Color(0xFFFFCB5F),
              size: 12,
            )),
          );
        } else {
          if (dataSnapshot.error != null) {
            Center(
              child: Text('An error occured'),
            );
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: result.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: NetworkImage(result[i].imageUrl),
                              fit: BoxFit.cover)),
                    ),
                    title: Text(result[i].title),
                    trailing: Text(result[i].price.toString() + " EGP"),
                    onTap: () {
                      query = result[i].title.toLowerCase();
                    },
                  );
                });
          }
        }
        return Center(
          child: Text("I have no products"),
        );
      },
    );
  }
}
