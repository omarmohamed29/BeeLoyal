import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../Providers/Users.dart';
import '../Providers/WalletManager.dart';

class ProfileData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10 , top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: users.users[0].name,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat-Light",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFCB5F),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: users.users[0].id,
                          style: TextStyle(
                            fontSize: 8,
                            fontFamily: "Montserrat-Light",
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline2.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: users.users[0].email,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat-Light",
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on,
                          size: 23, color:Theme.of(context).iconTheme.color),
                      Padding(
                          padding: const EdgeInsets.only(right: 80),
                          child: Container(
                            width: MediaQuery.of(context).size.width-240,
                            child: Text(
                              users.users[0].address,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                color: Theme.of(context).textTheme.headline6.color,
                              ),
                            ),
                          )),
                    ],
                  ),
                  FutureBuilder(
                    future: Provider.of<WalletManager>(context, listen: false)
                        .retrieveWallet(),
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: SpinKitChasingDots(
                          color: Colors.amberAccent,
                          size: 10,
                        ));
                      } else {
                        if (dataSnapshot.error != null) {
                          Center(
                            child: Text('An error occured'),
                          );
                        } else {
                          return Consumer<WalletManager>(
                            builder: (_, wallet, ch) => Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.stars,
                                      size: 30, color:Theme.of(context).iconTheme.color),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            wallet.wallet[0].points.toString(),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat-Light",
                                          color: Theme.of(context).textTheme.headline6.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Text(
                        " 0 ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
