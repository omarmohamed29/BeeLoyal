import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Providers/WalletManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../Providers/Purchase.dart';
import '../widgets/profile_icons.dart';

class WalletPage extends StatefulWidget {
  static const routeName = '/WalletPage';

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Future _userWallet;

  @override
  void initState() {
    _userWallet = getUser();
    super.initState();
  }

  getUser() async {
    return Provider.of<WalletManager>(context, listen: false).retrieveWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            left: 30,
            child: Column(
              children: <Widget>[
                IconButton(
                  alignment: Alignment.topLeft,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF3F3C36),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 40,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'My',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat-Bold",
                    fontSize: 40,
                    color: Color(0xFF3F3C36)),
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 100,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Wallet',
                style: TextStyle(
                    fontFamily: "Montserrat-Light",
                    fontSize: 40,
                    color: Color(0xFF3F3C36)),
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 30,
            right: 30,
            child: FutureBuilder(
              future: _userWallet,
              // ignore: missing_return
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
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
                    return Consumer<WalletManager>(
                      builder: (_, wallet, ch) =>
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color(0xFFFFCB5F).withOpacity(0.9)),
                            height: 170,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "You have in your credit ",
                                    style: TextStyle(
                                        fontFamily: "Montserrat-Light",
                                        fontSize: 20,
                                        color: Color(0xFF3F3C36)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Profile.cash,
                                            color: Color(0xFF3F3C36),
                                            size: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              wallet.wallet[0].money
                                                  .toString() +
                                                  " EGP",
                                              style: TextStyle(
                                                  fontFamily: "Montserrat-Light",
                                                  fontSize: 20,
                                                  color: Color(0xFF3F3C36)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            color: Color(0xFF3F3C36),
                                            size: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              wallet.wallet[0].points
                                                  .toString() +
                                                  " Point",
                                              style: TextStyle(
                                                  fontFamily: "Montserrat-Light",
                                                  fontSize: 20,
                                                  color: Color(0xFF3F3C36)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    wallet.wallet[0].id,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Montserrat-Light",
                                        fontSize: 5,
                                        color: Color(0xFF3F3C36)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "in your wallet you can find you current point , history of  transactions",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Montserrat-Light",
                                        fontSize: 8,
                                        color: Color(0xFF3F3C36)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    );
                  }
                }
              },
            ),
          ),
          Positioned(
            top: 220,
            right: 2,
            child: Container(
              width: 10,
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
                  color: Color(0xFFFFCB5F).withOpacity(0.9)),
            ),
          ),
          Positioned(
            top: 220,
            left: 2,
            child: Container(
              width: 10,
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                  color: Color(0xFFFFCB5F).withOpacity(0.9)),
            ),
          ),
          Positioned(
            top: 400,
            left: 30,
            right: 30,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Purchase History",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "Montserrat-Light",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF3F3C36)),
              ),
            ),
          ),
          Positioned(
            top: 420,
            left: 30,
            right: 30,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Payed/date",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat-Bold",
                        fontSize: 10,
                        color: Color(0xFF3F3C36).withOpacity(0.4)),
                  ),
                  trailing: Text(
                    "City",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat-Bold",
                        fontSize: 10,
                        color: Color(0xFF3F3C36).withOpacity(0.4)),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 455,
            left: 30,
            right: 30,
            child: FutureBuilder(
                future:
                Provider.of<Orders>(context, listen: false).fetchOrders(),
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
                      return Consumer<Orders>(
                        builder: (_, item, ch) =>
                        Container(
                          height: 400,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: item.orders.length,
                              itemBuilder: (ctx, i) =>
                              ListTile(
                                title: Text(
                                  item.orders[i].amount.toString() + "EGP",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat-Bold",
                                      fontSize: 10,
                                      color: Color(0xFF3F3C36)),
                                ),
                                subtitle:Text(
                                  DateFormat('dd/MM/yyy')
                                      .format (item.orders[i].datetime) ,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat-Bold",
                                      fontSize: 10,
                                      color: Color(0xFF3F3C36).withOpacity(0.7)),
                                ),
                                trailing: Text(
                                  item.orders[i].city,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat-Bold",
                                      fontSize: 10,
                                      color: Color(0xFF3F3C36)),
                                ),
                              )),
                        ),
                  );
                  }
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}
