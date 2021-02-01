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
  }

  _loadFromPrefs() async {

  }

  _setPrefs() async {
    _initPrefs();

  }


}