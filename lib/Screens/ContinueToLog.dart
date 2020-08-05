import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Providers/Users.dart';

class ContinueToLog extends StatefulWidget {
  final String email;

  ContinueToLog(this.email);

  @override
  _ContinueToLogState createState() => _ContinueToLogState();
}

class _ContinueToLogState extends State<ContinueToLog> {
  Map<String, String> _userData = {
    'Name': '',
    'Address': '',
    'email': '',
    'number': '',
  };

  var _currentSelected = 'Cairo';
  var _Cities = ['Cairo' , 'Giza' , 'Other'];


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _isLoading = false;

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
    if (!_formKey.currentState.validate()) {
      //invalid
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Users>(context, listen: false).addUser(
        _userData['Name'],
        _userData['Address'],
        widget.email,
        _currentSelected,
        _userData['number'],
      );
    } catch (error) {
      const errorMessage =
          'Could not Load. please check your internet connection and try again';
      _showErrorDIalod(errorMessage);
    }

    Navigator.of(context).pushReplacementNamed('/Licence');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1300, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Form(
        key: _formKey,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Image.asset("assets/images/Login2.png")
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(180),
                    ),

                    //this is the container that contains the form items like a card with form fields
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height-210,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, 15.0),
                                  blurRadius: 15.0),
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, -10.0),
                                  blurRadius: 10.0),
                            ]),
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Please Fill these fields",
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(45),
                                      fontFamily: "Poppins-Bold",
                                      letterSpacing: .6)),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Name",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty || value.contains('@')) {
                                    return 'Invalid Name ';
                                  }
                                  return null;
                                },
                                onSaved: (input) {
                                  _userData['Name'] = input;
                                },
                                decoration: InputDecoration(
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Address",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty || value.length < 5) {
                                    return 'Please give a full address';
                                  }
                                },
                                onSaved: (input) {
                                  _userData['Address'] = input;
                                },
                                decoration: InputDecoration(
                                    hintText: "Address",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),

                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
//
                              Text("Mobile Number",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty || value.contains('#') || value.length < 11) {
                                    return 'Invalid number ';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Mobile Number",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                                onSaved: (input) {
                                  _userData['number'] = input.toUpperCase();
                                },
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),

                          Text("City",
                              style: TextStyle(
                                   fontFamily: "Poppins-Medium",
                                    fontSize:
                                     ScreenUtil.getInstance().setSp(26))),
                            DropdownButton(
                              isExpanded: true,
                              items: _Cities.map((String dropDownStringItem){
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String newValue){
                                setState(() {
                                  this._currentSelected = newValue;
                                });
                              },
                              value: _currentSelected,
                            ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(26),
                              ),
//
                              // end of the form container /

                              SizedBox(
                                  height: ScreenUtil.getInstance().setHeight(40)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      width:
                                          ScreenUtil.getInstance().setWidth(330),
                                      height:
                                          ScreenUtil.getInstance().setHeight(100),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Color(0xFFFFE235),
                                            Color(0xFFFFC600)
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xFF6078ea)
                                                    .withOpacity(.3),
                                                offset: Offset(0.0, 8.0),
                                                blurRadius: 8.0)
                                          ]),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: _submit,
                                          child: _isLoading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Center(
                                                  child: Text("Continue",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "Poppins-Bold",
                                                          fontSize: 18,
                                                          letterSpacing: 1.0)),
                                                ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(40),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(40),
                              ),

                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
