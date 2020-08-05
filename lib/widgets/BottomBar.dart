import 'package:flutter/material.dart';
import '../Screens/HomePage.dart';
import '../Screens/ProfilePage.dart';
import '../Screens/SettingPage.dart';
import '../Screens/purchasePage.dart';
import 'nav_bar_icon_icons.dart';


// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  static const routeName = '/bottombar';
  int _selectedIndex = 0;

  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  var _pages = [
    HomePage(),
    ProfilePage(),
    PurchasePage(),
    SettingPage(),
  ];
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            widget._selectedIndex = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 13,
        fixedColor: Color(0xFFFFCB5F),
        iconSize: 25,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(NavBarIcon.home),
            title: Text(
              'Home',
              style: TextStyle(fontFamily: 'Montserrat-Light'),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(NavBarIcon.user),
            title: Text(
              'Profile',
              style: TextStyle(fontFamily: 'Montserrat-Light'),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(NavBarIcon.order),
            title: Text(
              'Orders',
              style: TextStyle(fontFamily: 'Montserrat-Light'),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(NavBarIcon.settings),
            title: Text(
              'Setting',
              style: TextStyle(fontFamily: 'Montserrat-Light'),
            ),
          ),
        ],
        currentIndex: widget._selectedIndex,
        onTap: (index) {
          setState(() {
            widget._selectedIndex = index;
            _pageController.animateToPage(widget._selectedIndex,
                duration: Duration(milliseconds: 100), curve: Curves.linear);
          });
        },
      ),
    );
  }
}
