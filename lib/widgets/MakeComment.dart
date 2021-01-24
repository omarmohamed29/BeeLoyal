import 'package:flutter/material.dart';
import 'package:loyalbee/Providers/Rates.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Providers/Comments.dart';
import '../Providers/Users.dart';
import '../widgets/details_icons.dart';

class MakeComment extends StatefulWidget {
  final productId;

  MakeComment(this.productId);

  @override
  _MakeCommentState createState() => _MakeCommentState();
}

class _MakeCommentState extends State<MakeComment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  Map<String, String> _commentData = {
    'name': '',
    'email': '',
    'body': '',
    'prodid': '',
  };
  double calculation = 0.0;
  int result = 0 ;

  int calculateSentiment(String trial) {
    if (trial.contains("+")) {
      String sentiment = trial.replaceAll('+', '');
      calculation = double.parse(sentiment);
      calculation = 5 - calculation;
      result = calculation.toInt();
      return result;
    } else if (trial.contains("-")) {
      String sentiment = trial.replaceAll('-', '');
      calculation = double.parse(sentiment);
      calculation = 5 - (3 + calculation);
      result = calculation.toInt();
      return result;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      //invalid
      return 'not validated';
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final trial =
          await Provider.of<Comments>(context, listen: false).sentimentAnalysis(
        _commentData['body'],
      );
      calculateSentiment(trial);
      try {
        await Provider.of<Comments>(context, listen: false).addComment(
          _commentData['name'],
          _commentData['email'],
          _commentData['body'],
          _commentData['prodid'],
          result.toString(),
        );
        await Provider.of<Rating>(context, listen: false)
            .addRate(result.toString(), widget.productId);
      } catch (error) {
        throw (error);
      }
    } catch (error) {
      throw (error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(right: 15),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Details.comment,
              size: 14,
              color: Color(0xFFFFCB5F),
            ),
          ),
          Text(
            "comment",
            style: TextStyle(
                fontSize: 13,
                color: Color(0xFFFFCB5F),
                fontFamily: "Montserrat-Light"),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => FutureBuilder(
              future: Provider.of<Users>(context, listen: false).retrieveUser(),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SpinKitCircle(color: Colors.amberAccent));
                } else {
                  if (dataSnapshot.error != null) {
                    Center(
                      child: Text('An error occured'),
                    );
                  } else {
                    return Consumer<Users>(
                      builder: (context, users, child) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: Text(
                            'Rate',
                            style: TextStyle(
                              fontFamily: "Montserrat-Light",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Form(
                            key: _formKey,
                            child: Container(
                              height: 170,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).textTheme.headline2.color),)
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: "Comment",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontFamily: "Montserrat-Light",
                                          )),
                                      keyboardType: TextInputType.text,

                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a comment  ';
                                        }
                                        return null;
                                      },
                                      onSaved: (input) {
                                        _commentData['body'] = input;
                                        _commentData['name'] =
                                            users.users[0].name;
                                        _commentData['email'] =
                                            users.users[0].email;
                                        _commentData['prodid'] = widget.productId;
                                      },
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 250,
                                      child: FlatButton(
                                        color: Color(0xFFFFCB5F),
                                        child: Text(
                                          'Rate Product',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          _submit();

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return Center(
                  child: Text("please login to comment and review"),
                );
              }),
        );
      },
    );
  }
}
