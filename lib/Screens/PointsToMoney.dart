import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../widgets/profile_icons.dart';
import 'package:provider/provider.dart';

import '../Providers/WalletManager.dart';

class PointsToMoney extends StatefulWidget {
  static const routeName = '/PointsToMoney';

  @override
  _PointsToMoneyState createState() => _PointsToMoneyState();
}

class _PointsToMoneyState extends State<PointsToMoney> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String userId;
  int point;
  int money;
  int limit;
  int amount = 0;

  Future<int> amountSet(amounts)async{
    return amount = amounts;
  }

  Future<void> updater(String id ,String amountOf ) async {
    await Provider.of<WalletManager>(context, listen: false)
        .pointsConverter(point, money);
    await Provider.of<WalletManager>(context, listen: false).updateWallet(id);
    Navigator.pop(context);
    final snackbar = SnackBar(
      content:
      Text("You Converted $amountOf to $amountOf"),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: "Got it",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void noEnoughMoney() {
    Navigator.pop(context);
    final snackbar = SnackBar(
      content:
          Text("you don't have enough points please scan QR to get points"),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: "Got it",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    userId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
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
                    Navigator.pop(context);
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
                'Points',
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
                'To money',
                style: TextStyle(
                    fontFamily: "Montserrat-Light",
                    fontSize: 40,
                    color: Color(0xFF3F3C36)),
              ),
            ),
          ),
          Positioned(
            top: 230,
            left: 20,
            right: 20,
            child: Text(
              "To buy something from the store you need to CHANGE POINTS TO MONEY. Down there you have 3 levels of changing (BRONZE-SLIVER-GOLD).",
              style: TextStyle(
                  fontFamily: "Montserrat-Light",
                  fontSize: 8,
                  color: Color(0xFF3F3C36)),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 280,
            left: 20,
            right: 20,
            child: Container(
                height: 500,
                child: FutureBuilder(
                    future: Provider.of<WalletManager>(context, listen: false)
                        .retrieveWallet(),
                    // ignore: missing_return
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: SpinKitWave(
                          color: Color(0xFF3F3C36),
                          type: SpinKitWaveType.start,
                          size: 12,
                        ));
                      } else {
                        if (dataSnapshot.error != null) {
                          Center(
                            child: Text('An error occured'),
                          );
                        } else {
                          return Consumer<WalletManager>(
                            builder: (_, check, ch) => Column(
                              children: <Widget>[
                                //Bronze level
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => NetworkGiffyDialog(
                                            image: Image.network(
                                              "https://media.giphy.com/media/ksE4eFvxZM3oyaFEVo/giphy.gif",
                                              fit: BoxFit.cover,
                                            ),
                                            buttonOkColor: Color(0xFFFFCB5F),
                                            buttonCancelColor:
                                                Color(0xFF3F3C36),
                                            title: Text(
                                              "Bronze level",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Montserrat-Bold",
                                                  fontSize: 20,
                                                  color: Color(0xFF3F3C36)),
                                            ),
                                            description: Text(
                                                "You're about to Convert 100 of your POINTS into 100 EGP , are you sure ! ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Montserrat-Light",
                                                    fontSize: 15,
                                                    color: Color(0xFF3F3C36)),
                                                textAlign: TextAlign.center),
                                            entryAnimation:
                                                EntryAnimation.BOTTOM,
                                            onOkButtonPressed: () async {
                                              money = 100;
                                              point = 100;
                                              limit = 100;
                                              check.wallet[0].points >= limit
                                                  ? updater(check.wallet[0].id , "100" )
                                                  : noEnoughMoney();

                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Bronze level",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Color(0xFF3F3C36),
                                                fontFamily: "Montserrat-Light"),
                                          ),
                                          Icon(
                                            Icons.star_border,
                                            color:  Color(0xFFFFCB5F),
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                //silver level
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => NetworkGiffyDialog(
                                            image: Image.network(
                                              "https://media.giphy.com/media/IGM2L443CYmLC/giphy.gif",
                                              fit: BoxFit.cover,
                                            ),
                                            buttonOkColor: Color(0xFFFFCB5F),
                                            buttonCancelColor:
                                                Color(0xFF3F3C36),
                                            title: Text(
                                              "Silver level",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Montserrat-Bold",
                                                  fontSize: 20,
                                                  color: Color(0xFF3F3C36)),
                                            ),
                                            description: Text(
                                                "You're about to Convert 300 of your POINTS into 300 EGP , are you sure ! ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Montserrat-Light",
                                                    fontSize: 15,
                                                    color: Color(0xFF3F3C36)),
                                                textAlign: TextAlign.center),
                                            entryAnimation:
                                                EntryAnimation.BOTTOM,
                                            onOkButtonPressed: () async {
                                              money = 300;
                                              point = 300;
                                              limit = 300;
                                              check.wallet[0].points >= limit
                                                  ? updater(check.wallet[0].id , "300")
                                                  : noEnoughMoney();
                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Silver level",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Color(0xFF3F3C36),
                                                fontFamily: "Montserrat-Light"),
                                          ),
                                          Icon(
                                            Icons.star_half,
                                            color:  Color(0xFFFFCB5F),
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                //Gold level
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => NetworkGiffyDialog(
                                            image: Image.network(
                                              "https://media.giphy.com/media/hvFUiCVOECDXJueNdy/giphy.gif",
                                              fit: BoxFit.cover,
                                            ),
                                            buttonOkColor: Color(0xFFFFCB5F),
                                            buttonCancelColor:
                                                Color(0xFF3F3C36),
                                            title: Text(
                                              "Gold level",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Montserrat-Bold",
                                                  fontSize: 20,
                                                  color: Color(0xFF3F3C36)),
                                            ),
                                            description: Text(
                                                "You're about to Convert 500 of your POINTS into 500 EGP , are you sure ! ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Montserrat-Light",
                                                    fontSize: 15,
                                                    color: Color(0xFF3F3C36)),
                                                textAlign: TextAlign.center),
                                            entryAnimation:
                                                EntryAnimation.BOTTOM,
                                            onOkButtonPressed: () async {
                                              money = 500;
                                              point = 500;
                                              limit = 500;
                                              check.wallet[0].points >= limit
                                                  ? updater(check.wallet[0].id , "500")
                                                  : noEnoughMoney();
                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Gold level",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Color(0xFF3F3C36),
                                                fontFamily: "Montserrat-Light"),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color:  Color(0xFFFFCB5F),
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                //Field to add points amount
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    width:100.0,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      textInputAction: TextInputAction.done,
                                      enableInteractiveSelection: false,
                                      style: TextStyle(
                                          color: Color(0xFFFFCB5F),),
                                      keyboardType: TextInputType.number,
                                      onChanged: (input) async {
                                        input.contains("-") ?
                                            amountSet(int.parse(input.replaceAll('-', ''))):
                                       await amountSet(int.parse(input));
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Points",
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0)),
                                    ),
                                  ),
                                ),

                                //loyal level
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => NetworkGiffyDialog(
                                              image: Image.network(
                                                "https://media.giphy.com/media/g0Kz3kG62fXJWSAW8B/giphy.gif",
                                                fit: BoxFit.cover,
                                              ),
                                              buttonOkColor: Color(0xFFFFCB5F),
                                              buttonCancelColor:
                                                  Color(0xFF3F3C36),
                                              title: Text(
                                                "Loyal level",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Montserrat-Bold",
                                                    fontSize: 20,
                                                    color: Color(0xFF3F3C36)),
                                              ),
                                              description: Text(
                                                  "You're about to Convert $amount of your POINTS into $amount EGP , are you sure ! ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Montserrat-Light",
                                                      fontSize: 15,
                                                      color: Color(0xFF3F3C36)),
                                                  textAlign: TextAlign.center),
                                              entryAnimation:
                                                  EntryAnimation.BOTTOM,
                                              onOkButtonPressed: () async {
                                                money = amount;
                                                point = amount;
                                                limit =  amount;
                                                check.wallet[0].points >= limit
                                                    ? updater(check.wallet[0].id , "$amount")
                                                    : noEnoughMoney();
                                              },
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Loyal level",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Color(0xFF3F3C36),
                                                  fontFamily:
                                                      "Montserrat-Light"),
                                            ),
                                            Icon(
                                             Profile.loyallevel,
                                              color:  Color(0xFFFFCB5F),
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    })),
          )
        ],
      ),
    );
  }
}
