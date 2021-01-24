import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Providers/Messages.dart';

class MessagesPage extends StatefulWidget {
  static const routeName = '/MessagesPage';

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Future _messagesFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _messagesFuture = getMessages();
    super.initState();
  }

  getMessages() async {
    return Provider.of<Messages>(context, listen: false).retrieveMessage();
  }

  Future<String> refresh() async {
    setState(() {
      _messagesFuture = getMessages();
    });

    return 'success';
  }

  void _onButtonPressed(String id) {
    final message =
        Provider.of<Messages>(context, listen: false).findById(id);
    _scaffoldKey.currentState.showBottomSheet(
         (context)=>FutureBuilder(
              future: _messagesFuture,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: SpinKitWave(
                      color: Colors.amberAccent,
                      type: SpinKitWaveType.start,
                      size: 20,
                    )),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    Center(
                      child: Text('An error occured'),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15)),
                        ),
                      height: MediaQuery.of(context).size.height * 45 / 100,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 5),
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(0),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "System Message",
                                  style: TextStyle(
                                      fontFamily: "Montserrat-bold",
                                      fontSize: 20,
                                      color:Theme.of(context).textTheme.headline2.color),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10 , bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Title : " + message.title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).textTheme.headline2.color,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat-bold"),
                                  ),
                                  Text(
                                    "Content : " + message.content,
                                    style: TextStyle(
                                        fontSize:13,
                                        color: Theme.of(context).textTheme.headline2.color,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat-light"),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: MaterialButton(
                                  color: Color(0xFFFFCB5F),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Done !",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat-bold"),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  }),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return Text("Error Occured");
                }
              }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        title: Row(
          children: <Widget>[
            Text(
              'System',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat-Bold",
                  fontSize: 20,
                  color: Theme.of(context).textTheme.headline2.color),
            ),
            Text(
              'Messages',
              style: TextStyle(
                  fontFamily: "Montserrat-Light",
                  fontSize: 20,
                  color: Theme.of(context).textTheme.headline2.color),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Messages>(context, listen: false).retrieveMessage(),
          // ignore: missing_return
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(200),
                child: Center(
                    child: SpinKitCircle(
                  color: Color(0xFFFFCB5F),
                  size: 15,
                )),
              );
            } else {
              if (dataSnapshot.error != null) {
                Center(
                  child: Text('An error occured'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<Messages>(
                    builder: (_, item, ch) => ListView.builder(
                      itemCount: item.messages.length,
                      itemBuilder: (ctx, i) => Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFFFCB5F), width: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          onTap: ()=>_onButtonPressed(item.messages[i].id),
                          trailing: Text("${i + 1}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat-bold",
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.headline2.color)),
                          title: Text(item.messages[i].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat-bold",
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.headline2.color)),
                          subtitle: Text(item.messages[i].content,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 10,
                                  color: Theme.of(context).textTheme.headline2.color)),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}
