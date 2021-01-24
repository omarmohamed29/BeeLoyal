import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyalbee/Screens/EditProfile.dart';
import 'package:loyalbee/Screens/WishList.dart';
import '../Screens/Vouchers.dart';
import '../Screens/WalletPage.dart';
import '../widgets/ProfileData.dart';
import '../Providers/Users.dart';
import 'package:provider/provider.dart';
import 'Messages.dart';
import 'PointsToMoney.dart';
import '../widgets/profile_icons.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/ProfilePage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  Future _userData;

  @override
  void initState() {
    _userData = getUser();
    super.initState();
  }

  getUser() async {
    return Provider.of<Users>(context, listen: false).retrieveUser();
  }

  Future<String> refresh() async {
    setState(() {
      _userData = getUser();
    });

    return 'success';
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
          onRefresh: refresh,
          color: Color(0xFFFFCB5F),
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Container(
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20, left: 15.0, bottom: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Bold",
                          fontSize: 30,
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: _userData,
                // ignore: missing_return
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    if (dataSnapshot.error != null) {
                      Center(
                        child: Text('An error occured'),
                      );
                    } else {
                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          ProfileData(),
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Center(
                        child: Text("Please Login First"),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 10, left: 10, bottom: 20),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).backgroundColor,
                      border: Border.all(color: Color(0xFFFFCB5F), width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(25.0),
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
                                          color: Theme.of(context).iconTheme.color,
                                          size: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          color: Theme.of(context).iconTheme.color,
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
                                              color:Theme.of(context).textTheme.headline2.color),
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
                                          color: Theme.of(context).iconTheme.color,
                                          size: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          color: Theme.of(context).iconTheme.color,
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
                                              color: Theme.of(context).textTheme.headline2.color),
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
                            color:Theme.of(context).backgroundColor,
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
                                          color: Theme.of(context).iconTheme.color,
                                          size: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          color: Theme.of(context).iconTheme.color,
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
                                              color: Theme.of(context).textTheme.headline2.color),
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
                                          color: Theme.of(context).iconTheme.color,
                                          size: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          color: Theme.of(context).iconTheme.color,
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
                                              color: Theme.of(context).textTheme.headline2.color),
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
                                          color: Theme.of(context).iconTheme.color,
                                          size: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          color: Theme.of(context).iconTheme.color,
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
                                              color: Theme.of(context).textTheme.headline2.color),
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
                                          color: Theme.of(context).iconTheme.color,
                                          size: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          color: Theme.of(context).iconTheme.color,
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
                                              color: Theme.of(context).textTheme.headline2.color),
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
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
