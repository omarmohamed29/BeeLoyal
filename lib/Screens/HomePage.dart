import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loyalbee/widgets/OfferCard.dart';
import 'ScanQr.dart';
import '../widgets/HomeProducts.dart';
import '../widgets/TrendingSection.dart';
import 'package:provider/provider.dart';
import '../Providers/Cart.dart';
import '../Screens/ShoppingCart.dart';
import '../widgets/badge.dart';
import 'dart:async';
import 'AllProducts.dart';
import '../Providers/Products.dart';
import '../Providers/WalletManager.dart';
import '../widgets/nav_bar_icon_icons.dart';
import '../widgets/profile_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  Future _productsFuture;
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  Future _usersFuture;
  String result = "";

  getProducts() async {
    return await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  getUsers() async {
    return await Provider.of<WalletManager>(context, listen: false)
        .retrieveWallet();
  }

  @override
  void initState() {
    _productsFuture = getProducts();
    _usersFuture = getUsers();
    if (_scrollController.hasClients) {
       _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
    super.initState();
  }

  Future<String> refresh() async {
    setState(() {
      _productsFuture = getProducts();
      _usersFuture = getUsers();
    });

    return 'success';
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: Color(0xFFFFCB5F),
                    height: 3,
                    width: 110,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Color(0xFFFFCB5F),
                      child: IconButton(
                        icon: Icon(
                          NavBarIcon.qrcode,
                          size: 50,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => QrScan()));
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Scan QR code",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline2.color,
                      fontFamily: "Montserrat-Light",
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/beel.png",
          width: 100,
          height: 60,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        actions: <Widget>[
          Consumer<Cart>(
              builder: (_, cart, ch) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Badge(
                      child: ch,
                      value: cart.itemCount.toString(),
                    ),
                  ),
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: IconButton(
                  icon: Icon(NavBarIcon.shoppingcart , color: Theme.of(context).iconTheme.color,),
                  color: Colors.black54,
                  iconSize: 20,
                  onPressed: () {
                    Navigator.of(context).pushNamed(ShoppingCart.routeName);
                  },
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add , color:  Theme.of(context).textTheme.headline2.color,),
          onPressed: () {
            _onButtonPressed();
          },
          label: Text(
            "More",
            style: TextStyle(
              fontFamily: "Montserrat-Bold",
              color: Theme.of(context).textTheme.headline2.color
            ),
          )),
      body: RefreshIndicator(
        onRefresh: refresh,
        color: Color(0xFFFFCB5F),
        child: FutureBuilder(
            future: _usersFuture,
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
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    children: <Widget>[
                      //The Top Section
                      Container(
                        decoration: BoxDecoration(
                            color:Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0))),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                        child: Text(
                                      "Hello there , ",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.headline2.color,
                                        fontFamily: "Montserrat-Light",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )),
                                    Center(
                                        child: Text(
                                      "Explore our latest products and get fashioned ! ",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.headline2.color,
                                        fontFamily: "Montserrat-Light",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: 350,
                                height: 1,
                                color: Theme.of(context).textTheme.headline2.color,
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Profile.wallet,
                                    color: Theme.of(context).textTheme.headline2.color,
                                    size: 30,
                                  ),
                                ),
                                Text("In your wallet you have",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.headline2.color,
                                      fontFamily: "Montserrat-Light",
                                      fontSize: 10,
                                    )),
                                Consumer<WalletManager>(
                                  builder: (_, wallet, ch) => Container(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30, top: 22),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Icon(
                                                Profile.cash,
                                                color: Theme.of(context).textTheme.headline2.color,
                                                size: 25,
                                              ),
                                            ),
                                            Text(
                                              wallet.wallet[0].money
                                                      .toString() +
                                                  " EGP",
                                              style: TextStyle(
                                                color: Theme.of(context).textTheme.headline2.color,
                                                fontFamily: "Montserrat-Light",
                                                fontSize: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Icon(
                                                Icons.star,
                                                color: Theme.of(context).textTheme.headline2.color,
                                                size: 25,
                                              ),
                                            ),
                                            Text(
                                              wallet.wallet[0].points
                                                      .toString() +
                                                  " Points",
                                              style: TextStyle(
                                                color: Theme.of(context).textTheme.headline2.color,
                                                fontFamily: "Montserrat-Light",
                                                fontSize: 22,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //offers Section
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: OfferCard(),
                      ),

                      //Featured Section
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFFFCB5F).withOpacity(0.9),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top:8.0 , bottom: 8 , left: 8),
                                child: Text(
                                  "Featured Products",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.headline2.color,
                                    fontFamily: "Montserrat-Light",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                child: TrendingSection(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, right: 10, left: 10, bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Color(0xFFFFCB5F), width: 1),
                            color: Theme.of(context).backgroundColor,
                          ),
                          height: 570,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Our Products",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.headline2.color,
                                          fontFamily: "Montserrat-Light",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          AllProducts()));
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Explore All",
                                              style: TextStyle(
                                                color: Color(0xFFFFCB5F),
                                                fontFamily: "Montserrat-Light",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Icon(Icons.arrow_forward,
                                                  size: 14,
                                                  color: Color(0xFFFFCB5F)),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                height: 500,
                                child: HomeProducts(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Center(child: Text("Please Login First"),),
                );
              }
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
