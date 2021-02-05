import 'package:flutter/material.dart';
import 'package:loyalbee/Providers/auth.dart';
import 'package:loyalbee/Screens/AllProducts.dart';
import 'package:loyalbee/Screens/MainCategories.dart';
import 'package:loyalbee/widgets/more_icons_icons.dart';
import 'package:loyalbee/widgets/setting_icons.dart';
import 'package:provider/provider.dart';
import 'nav_bar_icon_icons.dart';
import '../Screens/ProfilePage.dart';
import '../Screens/SettingPage.dart';
import '../Screens/purchasePage.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isNewRouteSameAsCurrent = false;

  List<String> texts = [
    'Home',
    'Products',
    'Profile',
    'Orders',
    'Setting',
    'Logout',
  ];

  List<bool> isHighlighted = [true, false, false, false, false, false];

  List<Icon> drawerIcon = [
    Icon(
      NavBarIcon.home,
      color: Color(0xFFFFCB5F),
    ),
    Icon(
      MoreIcons.tshirt,
      size: 30,
    ),
    Icon(NavBarIcon.user),
    Icon(NavBarIcon.order),
    Icon(NavBarIcon.settings),
    Icon(
      Setting.logout,
    ),
  ];

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List functionsDrawer = [
      () {
        Navigator.popUntil(context, (route) {
          if (route.settings.name == '/HomePage') {
            isNewRouteSameAsCurrent = true;
          }
          return true;
        });

        if (!isNewRouteSameAsCurrent) {
          Navigator.pop(context);
        }
      },
      () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AllProducts()));
      },
      () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ProfilePage()));
      },
      () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => PurchasePage()));
      },
      () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SettingPage()));
      },
      () {
        Provider.of<Auth>(context, listen: false).logout();
      },
    ];

    List<Widget> categories = [
      ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainCategories("Men", false)));
        },
        title: Text(
          'Men',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat-Light",
              color: Theme.of(context).textTheme.headline2.color,
              fontSize: 14),
        ),
      ),

      ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainCategories("Women", false)));
        },
        title: Text(
          'Women',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat-Light",
              color: Theme.of(context).textTheme.headline2.color,
              fontSize: 14),
        ),
      ),

      ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainCategories("Children", false)));
        },
        title: Text(
          'Children',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat-Light",
              color: Theme.of(context).textTheme.headline2.color,
              fontSize: 14),
        ),
      ),

      ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainCategories("Wallets", false)));
        },
        title: Text(
          'Wallets',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat-Light",
              color: Theme.of(context).textTheme.headline2.color,
              fontSize: 14),
        ),
      ),

      ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainCategories("Watches", false)));
        },
        title: Text(
          'Watches',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat-Light",
              color: Theme.of(context).textTheme.headline2.color,
              fontSize: 14),
        ),
      ),
    ];


    return Drawer(
      elevation: 8.0,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Core Navigation',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      color: Colors.grey,
                      fontSize: 12),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
              Container(
                height:  700,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: texts.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: () {
                          for (int i = 0; i < isHighlighted.length; i++) {
                            setState(() {
                              if (index == i) {
                                isHighlighted[index] = true;
                              } else {
                                //the condition to change the highlighted item
                                isHighlighted[i] = false;
                              }
                            });
                          }
                        },
                        child: Column(
                          children: [
                            texts[index] == 'Products'
                                ? Theme(
                              data:  Theme.of(context).copyWith(accentColor: Color(0xFFFFCB5F)),
                                  child: ExpansionTile(
                              backgroundColor: Theme.of(context).bottomSheetTheme.modalBackgroundColor,
                              children: categories,
                                      title: Row(
                                        children: [
                                          Icon(
                                            MoreIcons.tshirt,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Text(
                                            'Products',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat-Light",
                                                color: isHighlighted[index]
                                                    ? Color(0xFFFFCB5F)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .headline2
                                                        .color,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                )
                                : ListTile(
                                    leading: drawerIcon[index],
                                    title: Text(
                                      texts[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat-Light",
                                          color: isHighlighted[index]
                                              ? Color(0xFFFFCB5F)
                                              : Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .color,
                                          fontSize: 18),
                                    ),
                                    onTap: functionsDrawer[index],
                                  ),
                            SizedBox(
                              height: 7,
                            ),
                          ],
                        ));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'More Navigation',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      color: Colors.grey,
                      fontSize: 12),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.share,
                ),
                title: Text("Tell a friend",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat-Light",
                        color: Theme.of(context).textTheme.headline2.color,
                        fontSize: 18)),
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline_rounded,
                ),
                title: Text("Help and feedback",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat-Light",
                        color: Theme.of(context).textTheme.headline2.color,
                        fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
