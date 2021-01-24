import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ContinueToLog.dart';
import 'package:provider/provider.dart';

import '../Providers/auth.dart';

import '../models/http_exception.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  bool _passLook = true;
  final _passwordController = TextEditingController();

  void _showErrorDIalod(String message) {
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
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
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
        _showErrorDIalod(errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not login. please check your internet connection and try again';
        _showErrorDIalod(errorMessage);
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ContinueToLog(_authData['email'])));

    }else{
      return;
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
      backgroundColor: Colors.white,
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
                    Image.asset(
                      "assets/images/beel.png",
                      width: ScreenUtil.getInstance().setWidth(300),
                      height: ScreenUtil.getInstance().setHeight(200),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20),
                    ),

                    //this is the container that contains the form items like a card with form fields
                    Container(
                      width: double.infinity,
                      height: ScreenUtil.getInstance().setHeight(650),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Sign-Up",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(45),
                                    color: Color(0xFF3F3C36),
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
                            TextFormField(
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
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(50),
                            ),
                            Text("Password",
                                style: TextStyle(
                                    fontFamily: "Montserrat-Light",
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(35))),
                            TextFormField(
                              style: TextStyle(
                                fontFamily: "Montserrat-Light",
                              ),
                              controller: _passwordController,
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
                                    ),
                                  ),
                                  hintText:
                                      "Your password is hidden we won't sneak ",
                                  hintStyle: TextStyle(
                                      fontFamily: "Montserrat-Light",
                                      color: Colors.grey,
                                      fontSize: 12.0)),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(50),
                            ),
                            Text("Confirm Password",
                                style: TextStyle(
                                    fontFamily: "Montserrat-Light",
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(35))),
                            TextFormField(
                              style: TextStyle(
                                fontFamily: "Montserrat-Light",
                              ),
                              // ignore: missing_return
                              validator: (value) {
                                // ignore: unrelated_type_equality_checks
                                if (value != _passwordController.text) {
                                  return 'Password do not match !';
                                }
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Confirm your password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                    fontFamily: "Montserrat-Light",
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // end of the form container /

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(630),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _submit,
                                child: _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text("Complete your info...",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        "Montserrat-Bold",
                                                    fontSize: 18,
                                                    letterSpacing: 1.0)),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(60),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already a user ?   ",
                          style: TextStyle(
                            fontFamily: "Montserrat-Light",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: Text("SignIn",
                              style: TextStyle(
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