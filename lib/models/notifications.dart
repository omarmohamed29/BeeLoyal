import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ThemeChanger.dart';

class Notifications with ChangeNotifier{
  bool _muteNotification ;
  SharedPreferences prefs;

  bool get muteNotification => _muteNotification;
  Notifications(){
    _muteNotification = false;
    _loadFromPrefs();
  }

  toggleNotifications() {
    _muteNotification = !_muteNotification;
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
    _muteNotification = prefUserData['notifications'] == "true" ? true : false;
//    print("current theme is " + _darkTheme.toString());
//    print("saved one is " +
//        bool.fromEnvironment(prefUserData['theme']).toString());
  }

  _setPrefs() async {
    _initPrefs();
    final preferences = await SharedPreferences.getInstance();
    final userExperience = json.encode(
      {
        'theme': ThemeNotifier().darkTheme.toString(),
        'notifications' : _muteNotification.toString()
      },
    );
    await prefs.setString('userExperience', userExperience);
  }


}