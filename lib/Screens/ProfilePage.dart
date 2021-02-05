import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyalbee/widgets/profileTrailing.dart';

import '../widgets/ProfileData.dart';
import '../Providers/Users.dart';
import 'package:provider/provider.dart';

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
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: refresh,
            color: Color(0xFFFFCB5F),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
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
                  FutureBuilder(
                    future: _userData,
                    // ignore: missing_return
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          height: 20,
                        );
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
                SizedBox(height: 30,),
                ProfileTrailing(),
                ],
              ),
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
