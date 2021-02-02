import 'package:flutter/material.dart';

import 'package:loyalbee/Screens/EditProfile.dart';
import 'package:loyalbee/Screens/WishList.dart';
import '../Screens/Vouchers.dart';
import '../Screens/WalletPage.dart';
import '../Screens/Messages.dart';
import '../Screens/PointsToMoney.dart';
import '../widgets/profile_icons.dart';
import '../Providers/Users.dart';
import 'package:provider/provider.dart';

class ProfileTrailing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height - 305,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: Color(0xFFFFCB5F), width: 1)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Container(
                color: Color(0xFFFFCB5F),
                width: 50,
                height: 3,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                final users =
                Provider.of<Users>(context, listen: false);
                Navigator.of(context).pushNamed(
                    PointsToMoney.routeName,
                    arguments: users.users[0].id);
              },
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Profile.pointsconvert,
                            color:
                            Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Container(
                            color:
                            Theme.of(context).iconTheme.color,
                            height: 40,
                            width: 1,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Points to money",
                            style: TextStyle(
                                fontFamily: "Montserrat-Light",
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
              ),
            ),
          ),

          //Vouchers

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                final users =
                Provider.of<Users>(context, listen: false);
                Navigator.of(context).pushNamed(
                    VoucherPage.routeName,
                    arguments: users.users[0].name);
              },
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Profile.vouchers,
                            color:
                            Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Container(
                            color:
                            Theme.of(context).iconTheme.color,
                            height: 40,
                            width: 1,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Vouchers",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
              ),
            ),
          ),

          //wallet

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(WalletPage.routeName);
              },
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Profile.wallet,
                            color:
                            Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Container(
                            color:
                            Theme.of(context).iconTheme.color,
                            height: 40,
                            width: 1,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Wallet",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
              ),
            ),
          ),

          //wallet

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MessagesPage.routeName);
              },
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Profile.notification,
                            color:
                            Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Container(
                            color:
                            Theme.of(context).iconTheme.color,
                            height: 40,
                            width: 1,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Messages",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
              ),
            ),
          ),

          //OrdersPage

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.pushNamed(context, WishList.routeName);
              },
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.favorite_border,
                            color:
                            Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Container(
                            color:
                            Theme.of(context).iconTheme.color,
                            height: 40,
                            width: 1,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Wishlist",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
              ),
            ),
          ),

          //Edit Profile
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProfilePage.routeName);
              },
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.mode_edit,
                            color:
                            Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Container(
                            color:
                            Theme.of(context).iconTheme.color,
                            height: 40,
                            width: 1,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "EditProfile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
