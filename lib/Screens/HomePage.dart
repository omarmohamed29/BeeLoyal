import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loyalbee/Providers/Users.dart';
import 'package:loyalbee/widgets/OfferCard.dart';
import 'package:loyalbee/widgets/more_icons_icons.dart';
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
import '../widgets/TopSection.dart';
import '../widgets/Drawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {


  ScrollController _scrollController =
  ScrollController(initialScrollOffset: 0.0);

  Future _productsFuture;
  Future _walletFuture;
  Future _usersFuture;
  String result = "";

  getProducts() async {
    return await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  getUsers() async {
    return await Provider.of<Users>(context, listen: false)
        .retrieveUser();
  }
  getWallet()async{
    return  await Provider.of<WalletManager>(context, listen: false)
        .retrieveWallet();
  }

  @override
  void initState() {
    _productsFuture = getProducts();
    _walletFuture = getWallet();
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
      _walletFuture = getWallet();
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFFCB5F),
                    ),
                    height: 3,
                    width: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Center(
                    child: Column(
                      children: [
                        Text("More Tools", style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline2
                                .color
                        ) ,),
                        SizedBox(height: 10,),
                       ListTile(
                         leading: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Icon(
                             NavBarIcon.qrcode,
                             size: 30,
                           ),
                         ),
                         title:Text(
                           "Scan QR code",
                           style: TextStyle(
                             color: Theme
                                 .of(context)
                                 .textTheme
                                 .headline2
                                 .color,
                             fontFamily: "Montserrat-Bold",
                           ),
                         ),
                         subtitle: Text(
                           "Scan QR code and get points ",
                           style: TextStyle(
                             color: Theme
                                 .of(context)
                                 .textTheme
                                 .headline2
                                 .color,
                             fontFamily: "Montserrat-Light",
                             fontSize: 12
                           ),
                         ),
                         trailing: Icon(
                           Icons.chevron_right,
                           color:
                           Theme.of(context).textTheme.headline2.color,
                           size: 25,
                         ),
                         onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(
                               builder: (BuildContext context) => QrScan()));
                         },
                       )
                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
        });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              color: Theme.of(context).iconTheme.color,
              icon: Icon(MoreIcons.drawer),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        title:
        Theme
            .of(context)
            .backgroundColor == Color(0xFF121212)
            ? Image.asset(
          "assets/images/beel2.png",
          width: 100,
          height: 60,
        )
            : Image.asset(
          "assets/images/beel.png",
          width: 100,
          height: 60,
        ),
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        elevation: 0.0,
        actions: <Widget>[
          Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Badge(
                      child: ch,
                      value: cart.itemCount.toString(),
                    ),
                  ),
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: IconButton(
                  icon: Icon(NavBarIcon.shoppingcart, color: Theme
                      .of(context)
                      .iconTheme
                      .color,),
                  color: Colors.black54,
                  iconSize: 20,
                  onPressed: () {
                    Navigator.of(context).pushNamed(ShoppingCart.routeName);
                  },
                ),
              )),
        ],
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor:  Color(0xFFFFCB5F),

          icon: Icon(Icons.add, color: Theme
              .of(context)
              .textTheme
              .headline2
              .color,),
          onPressed: () {
            _onButtonPressed();
          },
          label: Text(
            "More",
            style: TextStyle(
                fontFamily: "Montserrat-Bold",
                color: Theme
                    .of(context)
                    .textTheme
                    .headline2
                    .color
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
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      children: <Widget>[
                        //The Top Section
                        TopSection(),
                        SizedBox(height: 15,),
                        //offers Section
                        OfferCard(),

                        //Featured Section
                        SizedBox(height: 15,),
                        Card(
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            height: 250,
                            decoration: Theme.of(context).backgroundColor == Color(0xFF121212) ? null : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFFCB5F).withOpacity(0.9),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8, left: 8),
                                  child: Text(
                                    "Featured Products",
                                    style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline2
                                          .color,
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

                        //All products
                        SizedBox(height: 15,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                            Border.all(color: Color(0xFFFFCB5F), width: 1),
                            color: Theme
                                .of(context)
                                .backgroundColor,
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
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline2
                                              .color,
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
                              HomeProducts(),
                            ],
                          ),
                        )


                      ],
                    ),
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
