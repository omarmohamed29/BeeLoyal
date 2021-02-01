import 'package:flutter/material.dart';
import 'package:loyalbee/Providers/Users.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = '/EditProfilePage';

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> _userData = {
    'name': '',
    'address': '',
    'number':'',
  };
  var _currentSelected = 'Cairo';
  var _Cities = ['Cairo' , 'Giza' , 'Other'];

  Future<void> _submit() async {
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Users>(context, listen: false).retrieveUser();
      final oldUserInfo = Provider.of<Users>(context, listen:false).users;
      await Provider.of<Users>(context, listen: false)
          .editUser(_userData['name'], _userData['address'] , oldUserInfo[0].id , _currentSelected , _userData['number']);
    } catch (error) {
      throw error;
    }
    setState(() {
      _isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    Provider.of<Users>(context, listen: false).retrieveUser();
    final oldUserInfo = Provider.of<Users>(context, listen:false).users;
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 50,
              left: 30,
              child: Column(
                children: <Widget>[
                  IconButton(
                    alignment: Alignment.topLeft,
                    icon: Icon(
                      Icons.arrow_back,
                      color:Theme.of(context).textTheme.headline2.color,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 100,
              left: 40,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Bold",
                      fontSize: 40,
                      color:  Color(0xFFFFCB5F)),
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: 100,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: "Montserrat-Light",
                      fontSize: 40,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
            ),
            Positioned(
                top: 250,
                left: 20,
                right: 20,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Change Name',
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).textTheme.headline2.color),)
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        initialValue: oldUserInfo[0].name,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                           return;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userData['name'] = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Change your IN APP name",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Change Address',
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).textTheme.headline2.color),)
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        initialValue: oldUserInfo[0].address,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                           return ;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userData['address'] = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Do you want to change  your address ?! ",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Change Mobile Number',
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).textTheme.headline2.color),)
                      ),
                      width: MediaQuery.of(context).size.width,
                      child:
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        initialValue: oldUserInfo[0].phoneNumber,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Change City',
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton(
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
                    ),

                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      color:  Color(0xFFFFCB5F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        _submit();
                      },
                      child: _isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Color(0xFFFFCB5F),
                            )
                          : Text("Submit Changes",
                              style: TextStyle(
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.headline2.color)),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
