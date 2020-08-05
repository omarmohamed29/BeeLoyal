import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/setting_icons.dart';
import '../Providers/auth.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 5,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Setting",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Bold",
                          fontSize: 30,
                          color: Color(0xFF3F3C36)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10 ,
              right: 10,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                        child: Container(
                          color: Colors.white,
                          width: 100,
                          height: 2,
                        ),
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(left: 15.0 , top: 80),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Customize your experince",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat-Bold",
                              fontSize: 18,
                              color: Color(0xFF3F3C36)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          FlatButton(
                            child: Padding(
                              padding: const EdgeInsets.only(top:20.0 , bottom: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Setting.rateus , color: Color(0xFF3F3C36),size: 30,),
                                  Padding(
                                    padding: const EdgeInsets.only(left : 15.0),
                                    child: Text("Rate us" , style: TextStyle(
                                        fontFamily: "Montserrat-Light",
                                        fontSize: 25,
                                        color: Color(0xFF3F3C36))),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: (){},
                          ),

                          FlatButton(
                            child: Padding(
                              padding: const EdgeInsets.only(top:20.0 , bottom: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Setting.socialize, color: Color(0xFF3F3C36),size: 30,),
                                  Padding(
                                    padding: const EdgeInsets.only(left : 15.0),
                                    child: Text("Contact us" , style: TextStyle(
                                        fontFamily: "Montserrat-Light",
                                        fontSize: 25,
                                        color: Color(0xFF3F3C36))),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: (){},
                          ),

                          FlatButton(
                            child: Padding(
                              padding: const EdgeInsets.only(top:20.0 , bottom: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Setting.licence , color: Color(0xFF3F3C36),size: 30,),
                                  Padding(
                                    padding: const EdgeInsets.only(left : 15.0),
                                    child: Text("License" , style: TextStyle(
                                        fontFamily: "Montserrat-Light",
                                        fontSize: 25,
                                        color: Color(0xFF3F3C36))),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: (){},
                          ),

                          FlatButton(
                            child: Padding(
                              padding: const EdgeInsets.only(top:20.0 , bottom: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Setting.logout , color: Color(0xFF3F3C36),size: 30,),
                                  Padding(
                                    padding: const EdgeInsets.only(left : 15.0),
                                    child: Text("Logout" , style: TextStyle(
                                        fontFamily: "Montserrat-Light",
                                        fontSize: 25,
                                        color: Color(0xFF3F3C36))),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: (){
                             Provider.of<Auth>(context , listen: false).logout();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
