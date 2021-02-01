import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Providers/auth.dart';

import '../models/http_exception.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  bool _passLook = true;

  void _showErrorDialod(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error Occured!'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      //invalid
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signIn(_authData['email'], _authData['password']);
    } on HttpException catch (error) {
      var errorMessage = 'Login faild try again';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use. ';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address. ';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak. ';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email. ';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password. ';
      }
      _showErrorDialod(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not login. please check your internet connection and try again';
      _showErrorDialod(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomPadding: true,
      body: Form(
        key: _formKey,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Theme.of(context).backgroundColor == Color(0xFF121212)
                        ? Image.asset(
                            "assets/images/beel2.png",
                            width: ScreenUtil.getInstance().setWidth(300),
                            height: ScreenUtil.getInstance().setHeight(200),
                          )
                        : Image.asset(
                            "assets/images/beel.png",
                            width: ScreenUtil.getInstance().setWidth(300),
                            height: ScreenUtil.getInstance().setHeight(200),
                          ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20),
                    ),

                    //this is the container that contains the form items like a card with form fields
                    Card(
                      child: Container(
                        height: MediaQuery.of(context).size.height-450,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.0 , left: 12 , right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Sign-In",
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(45),
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .color,
                                      fontFamily: "Montserrat-Bold",
                                      letterSpacing: .6)),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(50),
                              ),
                              Text("Email",
                                  style: TextStyle(
                                      fontFamily: "Montserrat-Light",
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(35))),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 0.5,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .color),
                                )),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: "Montserrat-Light",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty || !value.contains('@')) {
                                      return 'Invalid Email ';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) {
                                    _authData['email'] = input;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Give us your email please",
                                      hintStyle: TextStyle(
                                          fontFamily: "Montserrat-Light",
                                          color: Colors.grey,
                                          fontSize: 12.0)),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(50),
                              ),
                              Text("Password",
                                  style: TextStyle(
                                      fontFamily: "Montserrat-Light",
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(35))),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 0.5,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .color),
                                )),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontFamily: "Montserrat-Light",
                                  ),
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 5) {
                                      return 'Password is too short !';
                                    }
                                  },
                                  onSaved: (input) {
                                    _authData['password'] = input;
                                  },
                                  obscureText: _passLook,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _passLook = !_passLook;
                                          });
                                        },
                                        child: Icon(
                                          _passLook
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 20,
                                          color: Color(0xFFFFCB5F),
                                        ),
                                      ),
                                      hintText:
                                          "Your password is hidden we won't sneak ",
                                      hintStyle: TextStyle(
                                          fontFamily: "Montserrat-Light",
                                          color: Colors.grey,
                                          fontSize: 12.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // end of the form container /
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(50),
                    ),
                    FlatButton(
                      height: 50,
                      color: Color(0xFFFFCB5F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: _submit,
                      child: Center(
                      child: _isLoading
                                    ? Center(
                                        child: SpinKitCircle(
                                        color: Colors.white,
                                        size: 22,
                                      ))
                                    :Text("Welcome to BEE",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat-Bold",
                              fontSize: 18,
                              letterSpacing: 1.0)),
                    ),
                    ),

                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(60),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account yet ?  ",
                          style: TextStyle(
                              fontFamily: "Montserrat-Light",
                              color:
                                  Theme.of(context).textTheme.headline2.color),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text("SignUp",
                              style: TextStyle(
                                color: Color(0xFFFFCB5F),
                                fontFamily: "Montserrat-Light",
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
