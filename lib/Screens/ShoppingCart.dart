import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loyalbee/Providers/Users.dart';
import 'package:provider/provider.dart';
import '../Providers/Cart.dart' show Cart;
import '../widgets/CartCard.dart';
import '../Providers/Purchase.dart';
import '../Providers/WalletManager.dart';

class ShoppingCart extends StatefulWidget {
  static const routeName = '/ShoopingCart';

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _userFuture;
  double Delivery = 0.0;

  getUsers() async {
    return await Provider.of<Users>(context, listen: false).retrieveUser();
  }

  @override
  void initState() {
    _userFuture = getUsers();
    super.initState();
  }

  Future<void> toCart(int total, String id) async {
    final cart = Provider.of<Cart>(context, listen: false);
    final userData = Provider
        .of<Users>(context, listen: false)
        .users[0];
    await Provider.of<WalletManager>(context, listen: false).purchase(total);
    await Provider.of<WalletManager>(context, listen: false).updateWallet(id);
    await Provider.of<Orders>(context, listen: false)
        .addOrders(
        cart.items.values.toList(), total.toDouble(), userData.address,
        userData.phoneNumber, userData.city);
    cart.clear();
  }

  void noEnoughMoney() {
    final snackbar = SnackBar(
      content: Text(
          "you don't have enough points please scan QR to get points" ,style: TextStyle(color: Theme.of(context).textTheme.headline2.color),),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: "Got it",
        textColor: Theme.of(context).textTheme.headline2.color,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final userData = Provider
        .of<Users>(context, listen: false)
        .users[0];
    userData.city.toLowerCase() == 'cairo' || userData
        .city.toLowerCase() == 'giza' ? Delivery = 30.0 : Delivery = 60.0 ;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 125.0, left: 70),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Cart',
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
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) =>
                    CartItem(
                        cart.items.values.toList()[i].id,
                        cart.items.keys.toList()[i],
                        cart.items.values.toList()[i].price,
                        cart.items.values.toList()[i].quantity,
                        cart.items.values.toList()[i].title,
                        cart.items.values.toList()[i].image),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Delivery:",
                          style: TextStyle(
                              fontFamily: "Montserrat-Light",
                              fontSize: 20,
                              color: Theme.of(context).textTheme.headline2.color),
                        ),
                        Text(
                          Delivery.toStringAsFixed(2) + 'EGP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat-Bold",
                              fontSize: 20,
                              color: Theme.of(context).textTheme.headline2.color),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "total:",
                          style: TextStyle(
                              fontFamily: "Montserrat-Light",
                              fontSize: 20,
                              color: Theme.of(context).textTheme.headline2.color),
                        ),
                        Text(
                          cart.totalCash <= 0 ? cart.totalCash.toStringAsFixed(2) + 'EGP' : (cart.totalCash + Delivery).toStringAsFixed(2) +
                          'EGP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat-Bold",
                              fontSize: 20,
                              color: Theme.of(context).textTheme.headline2.color),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "In wallet:",
                            style: TextStyle(
                                fontFamily: "Montserrat-Light",
                                fontSize: 20,
                                color: Theme.of(context).textTheme.headline2.color),
                          ),
                          FutureBuilder(
                            future: Provider.of<WalletManager>(context,
                                listen: false)
                                .retrieveWallet(),
                            builder: (ctx, dataSnapshot) {
                              if (dataSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: SpinKitDoubleBounce(
                                      color:Theme.of(context).textTheme.headline2.color,
                                      size: 12,
                                    ));
                              } else {
                                if (dataSnapshot.error != null) {
                                  Center(
                                    child: Text('An error occured'),
                                  );
                                } else {
                                  return Consumer<WalletManager>(
                                    builder: (_, money, ch) =>
                                        Text(
                                          money.wallet[0].money.toString() +
                                              "  EGP",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat-Bold",
                                              fontSize: 20,
                                              color: Theme.of(context).textTheme.headline2.color),
                                        ),);
                                }
                                return Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat-Bold",
                                      fontSize: 20,
                                      color: Theme.of(context).textTheme.headline2.color),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            FutureBuilder(
              future: Provider.of<WalletManager>(context,
                  listen: false)
                  .retrieveWallet(),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child: SpinKitDoubleBounce(
                        color: Color(0xFF3F3C36),
                        size: 12,
                      ));
                } else {
                  if (dataSnapshot.error != null) {
                    Center(
                      child: Text('An error occured'),
                    );
                  } else {
                    return Consumer<WalletManager>(
                      builder: (_, money, ch) =>
                          Padding(
                            padding: EdgeInsets.only(
                                top: 9, left: 9, right: 9, bottom: 15),
                            child: RaisedButton(
                              color: Color(0xFFFFCB5F),
                              textColor: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'Proceed to Purchase',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Icon(Icons.payment)
                                  ],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: cart.totalCash <= 0
                                  ? null
                                  : () async {
                                money.wallet[0].money >= (cart.totalCash + Delivery)
                                    ?
                                toCart(
                                    (cart.totalCash + Delivery).toInt(), money.wallet[0].id)
                                    : noEnoughMoney();
                              },
                            ),
                          ),);
                  }
                  return Text(
                    "0",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat-Bold",
                        fontSize: 20,
                        color: Color(0xFF3F3C36)),
                  );
                }
              },
            )

          ],
        ),
      ),
    );
  }
}
