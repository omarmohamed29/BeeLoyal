import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications.dart';

class AppTheme {
  get myDarkTheme => ThemeData(
    primarySwatch: Colors.amber,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor:  Color(0xFFFFCB5F),
    ),
    appBarTheme: AppBarTheme(
      color: Color(0xFF111111),
      brightness: Brightness.dark,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xFF2F3136),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      modalElevation: 2.2,
      modalBackgroundColor:  Color(0xFF121212),
    ),

    brightness: Brightness.dark,
    backgroundColor: Color(0xFF111111),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
        headline2: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.grey)),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: Colors.white),
      border: InputBorder.none,
    ),


    accentIconTheme: IconThemeData(color: Colors.white),
    hoverColor: Colors.white.withOpacity(0.1),
    cursorColor: Colors.pinkAccent,
    textSelectionColor: Colors.pinkAccent,
  );

  get myLightTheme => ThemeData(
      primarySwatch: Colors.amber,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor:  Color(0xFFFFCB5F),
      ),
      appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color:Colors.white,
           elevation: 0.0,
            iconTheme: IconThemeData(
              color: Color(0xFF111111), //change your color here
        ),
      ),
      backgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.white),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        modalElevation: 2.2,
      ),

      iconTheme: IconThemeData(color: Colors.black),
      brightness: Brightness.light,
      textTheme: TextTheme(
          headline2: TextStyle(color:Color(0xFF3F3C36)),
          headline6: TextStyle(color: Colors.black26)),
      accentIconTheme: IconThemeData(color: Colors.black),
      hoverColor: Color(0xFFF2F5FA),
      cursorColor: Colors.pinkAccent,
      textSelectionColor: Colors.pinkAccent,
      accentColor: Colors.pinkAccent);
}

class ThemeNotifier with ChangeNotifier {
  bool _darkTheme;
  SharedPreferences prefs;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _setPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final prefUserData = await json.decode(prefs.getString('userExperience'))
    as Map<String, Object>;
    _darkTheme = prefUserData['theme'] == "true" ? true : false;
//    print("current theme is " + _darkTheme.toString());
//    print("saved one is " +
//        bool.fromEnvironment(prefUserData['theme']).toString());
  }

  _setPrefs() async {
    _initPrefs();
    final preferences = await SharedPreferences.getInstance();
    final userExperience = json.encode(
      {
        'theme': _darkTheme.toString(),
        'notifications' : Notifications().muteNotification.toString()
      },
    );
    await prefs.setString('userExperience', userExperience);
  }
}
