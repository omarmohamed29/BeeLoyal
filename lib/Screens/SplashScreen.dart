import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../Providers/Users.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _usersFuture;

  getUsers() async {
    return await Provider.of<Users>(context, listen: false).retrieveUser();
  }

  @override
  void initState() {
    super.initState();
    _usersFuture = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
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
                } else {}
              }
              return Container();
            }),
      ),
    );
  }
}
