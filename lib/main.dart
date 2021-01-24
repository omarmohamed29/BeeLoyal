import 'package:flutter/material.dart';
import 'package:loyalbee/models/notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Providers/Offers.dart';
import 'Providers/Rates.dart';
import 'Providers/Voucher.dart';
import 'Providers/Comments.dart';
import 'Providers/QrScanner.dart';
import 'Providers/WalletManager.dart';
import 'Providers/Cart.dart';
import 'Providers/Users.dart';
import 'Providers/Purchase.dart';
import 'Providers/auth.dart';
import 'Providers/Products.dart';
import 'Providers/Messages.dart';

import 'package:loyalbee/Screens/WishList.dart';
import 'Screens/EditProfile.dart';
import 'Screens/Messages.dart';
import 'Screens/Licence.dart';
import 'Screens/Login.dart';
import 'Screens/Signup.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/PointsToMoney.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/Vouchers.dart';
import 'Screens/WalletPage.dart';
import 'Screens/Welcome.dart';
import 'Screens/ShoppingCart.dart';

import 'models/Product.dart';
import 'models/ThemeChanger.dart';
import 'models/User.dart';

import 'widgets/BottomBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  String textValue ;
  @override
  void initState() {
    super.initState();
    _messaging.configure(
        // ignore: missing_return
        onLaunch: (Map<String, dynamic> msg) {
      print("onLaunch called");
    },
        // ignore: missing_return
        onResume: (Map<String, dynamic> msg) {
      print("onLaunch called");
    },
        // ignore: missing_return
        onMessage: (Map<String, dynamic> msg) {
      print("onLaunch called");
    });
    _messaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      ),
    );
    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print("IOS Setting Registered");
    });

    _messaging.getToken().then((token) {
      update(token);
    });
  }

  update(String token){
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token" : token});
    textValue = token;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
    child:Consumer<ThemeNotifier>(
    builder: (context , ThemeNotifier notifier , child){
      return  MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: Auth(),
            ),
            ChangeNotifierProvider.value(
              value: Products(),
            ),
            ChangeNotifierProvider.value(
              value: Cart(),
            ),
            ChangeNotifierProvider.value(
              value: Users(),
            ),
            ChangeNotifierProvider.value(
              value: User(),
            ),
            ChangeNotifierProvider.value(
              value: Orders(),
            ),
            ChangeNotifierProvider.value(
              value: Comments(),
            ),
            ChangeNotifierProvider.value(
              value: WalletManager(),
            ),
            ChangeNotifierProvider.value(
              value: GetPoints(),
            ),
            ChangeNotifierProvider.value(
              value: Product(),
            ),
            ChangeNotifierProvider.value(
              value: Offers(),
            ),
            ChangeNotifierProvider.value(
              value: Vouchers(),
            ),
            ChangeNotifierProvider.value(
              value: Rating(),
            ),
            ChangeNotifierProvider.value(
              value: Messages(),
            ),
            ChangeNotifierProvider.value(
              value: Notifications(),
            ),

          ],
          child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
              title: 'Bee Loyal',
              debugShowCheckedModeBanner: false,
              theme:  notifier.darkTheme
                  ? AppTheme().myDarkTheme
                  : AppTheme().myLightTheme,
              routes: <String, WidgetBuilder>{
                '/welcome': (BuildContext context) => new Welcome(),
                ShoppingCart.routeName: (ctx) => ShoppingCart(),
                ProfilePage.routeName: (ctx) => ProfilePage(),
                '/signup': (BuildContext context) => SignUp(),
                '/bottombar': (BuildContext context) => BottomBar(),
                '/login': (BuildContext context) => Login(),
                '/PointsToMoney': (BuildContext context) => PointsToMoney(),
                '/WalletPage': (BuildContext context) => WalletPage(),
                '/Licence': (BuildContext context) => Licence(),
                '/VoucherPage': (BuildContext context) => VoucherPage(),
                '/MessagesPage': (BuildContext context) => MessagesPage(),
                '/EditProfilePage': (BuildContext context) => EditProfilePage(),
                '/wishList': (BuildContext context) => WishList(),
              },
              home: auth.isAuth
                  ? BottomBar()
                  : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState ==
                    ConnectionState.waiting
                    ? SplashScreen()
                    : Login(),
              ),
            ),
          ));
    }));
  }
}
