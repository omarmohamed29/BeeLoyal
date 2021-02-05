import 'package:flutter/material.dart';

import 'DataBase.dart';

class AppTheme {
  get myDarkTheme => ThemeData(
    primarySwatch: Colors.amber,

    appBarTheme: AppBarTheme(
      color: Color(0xFF111111),
      brightness: Brightness.dark,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor:Color(0xFF2D2D2D),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      modalElevation: 2.2,
      modalBackgroundColor:  Color(0xFF121212),

    ),
    cardTheme: CardTheme(
      color: Color(0xFF1E1E1E),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),

    brightness: Brightness.dark,
    backgroundColor: Color(0xFF121212),
    iconTheme: IconThemeData(color: Colors.white ),
    textTheme: TextTheme(
        headline2: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.grey)),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: Colors.white),
      border: InputBorder.none,
    ),

    textSelectionHandleColor:Color(0xFFFFCB5F),
    hoverColor: Colors.white.withOpacity(0.1),
    cursorColor: Color(0xFFFFCB5F),
    textSelectionColor: Color(0xFFFFCB5F),
    unselectedWidgetColor: Color(0xFFFFCB5F),
  );

  get myLightTheme => ThemeData(
      primarySwatch: Colors.amber,
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
        backgroundColor: Colors.white,
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
      hoverColor: Color(0xFFF2F5FA),
      cursorColor: Color(0xFFFFCB5F),
      textSelectionColor: Color(0xFFFFCB5F),
  );
}

class ThemeNotifier with ChangeNotifier {
  bool _darkTheme;

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

  Future<bool> _loadFromPrefs() async {
    final _userData = await DBProvider.db.getUsers();
    Map<String, String> newUser =  Map<String, String>.from(_userData);
    print(newUser.containsKey('theme'));
    print(newUser['theme']);
    _darkTheme = newUser['theme'] == "true" ? true : false;
    notifyListeners();
    return _darkTheme;

  }

  _setPrefs() async {
    final _userData = await DBProvider.db.getUsers();
    _userData == null
        ? await DBProvider.db.setTheme(_darkTheme.toString())
        : await DBProvider.db.update(_darkTheme.toString());
  }
}
