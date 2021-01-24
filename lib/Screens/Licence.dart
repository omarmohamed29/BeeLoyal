import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Providers/Users.dart';
import '../Providers/WalletManager.dart';

class Licence extends StatelessWidget {
  static const routeName = '/Licence';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Licence",
                style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 30,
                    color: Theme.of(context).textTheme.headline2.color),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30.0 , right: 30),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text:
                        'Copyright 2020 The Bee Loyal Authors. All rights reserved.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color.withOpacity(0.6),
                      fontFamily: "Montserrat-light",
                    ),
                  ),
                  TextSpan(
                    text:
                        'Welcome to Bee  loyal app you are about to get a Signup Gift of 100 POINTS use them wisely',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color.withOpacity(0.6),
                      fontFamily: "Montserrat-light",
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: FutureBuilder(
                future:
                    Provider.of<Users>(context, listen: false).retrieveUser(),
                // ignore: missing_return
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitWave(
                      color: Colors.amberAccent,
                      type: SpinKitWaveType.start,
                      size: 12,
                    ));
                  } else {
                    if (dataSnapshot.error != null) {
                      Center(
                        child: Text('An error occured'),
                      );
                    } else {
                      return FlatButton(
                        child: Text(
                          'Getting Started',
                          style: TextStyle(fontSize: 18),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(15),
                        color: Colors.amber,
                        textColor: Colors.white,
                        onPressed: () async {
                          await Provider.of<WalletManager>(context, listen: false)
                              .addToWallet(0, 100);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.of(context)
                              .pushReplacementNamed('/bottombar');
                        },
                      );
                    }
                  }
                  return Text("Something went wrong , please try again later");
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
