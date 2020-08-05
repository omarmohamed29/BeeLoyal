import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loyalbee/Screens/orderDetails.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Providers/Purchase.dart';

class PurchaseCard extends StatefulWidget {
  final bool status;

  PurchaseCard({this.status});

  @override
  _PurchaseCardState createState() => _PurchaseCardState();
}

class _PurchaseCardState extends State<PurchaseCard>
    with AutomaticKeepAliveClientMixin<PurchaseCard> {
  var _expanded = false;
  Future _orderFuture;

  @override
  void initState() {
    _orderFuture = getOrders();
    super.initState();
  }

  getOrders() async {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  Future<String> refresh() async {
    setState(() {
      _orderFuture = getOrders();
    });

    return 'success';
  }

  void _onButtonPressed(String id) {
    final ordersData = Provider.of<Orders>(context, listen: false).findById(id);
    final prod = ordersData.products[0];
    showBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: _orderFuture,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15) , topLeft: Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.grey[300],
                                spreadRadius: 5)
                          ]),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 45 / 100,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 5),
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Order Summary",
                                  style: TextStyle(
                                      fontFamily: "Montserrat-bold",
                                      fontSize: 20,
                                      color: Color(0xFF3F3C36)),
                                ),
                              ),
                            ),
                            Container(
                              child: Stepper(
                                controlsBuilder: (BuildContext context,
                                    {VoidCallback onStepContinue,
                                      VoidCallback onStepCancel}) {
                                  return Container();
                                },
                                steps: [
                                  Step(
                                    title: Text(
                                      "Order Placed on  " +
                                          DateFormat('dd/MM/yyy')
                                              .format(ordersData.datetime),
                                    ),
                                    content: Text(""),
                                    isActive: true,
                                    state: StepState.complete,
                                  ),
                                  Step(
                                    title: Text("Order is on it's way "),
                                    content: Text(""),
                                    isActive: true,
                                    state: StepState.complete,
                                  ),
                                  Step(
                                    title: Text("Order Delivered"),
                                    content: Text(""),
                                    isActive: ordersData.status == true
                                        ? true
                                        : false,
                                    state: ordersData.status == true
                                        ? StepState.complete
                                        : StepState.error,
                                  )
                                ],
                                currentStep:
                                ordersData.status == true ? 2 : 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25 , right: 25),
                              child: MaterialButton(
                                  color: Color(0xFFFFCB5F),
                                  padding: EdgeInsets.all(5),
                                  child: Text("Done !",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat-bold"),),
                                  shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return Text("Error Occured");
                }
              });
        });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List orders = Provider
        .of<Orders>(context)
        .orders;
    widget.status == false
        ? orders = orders.where((x) => x.status == false).toList()
        : widget.status == true
        ? orders = orders.where((x) => x.status == true).toList()
        : orders = orders;
    return RefreshIndicator(
      onRefresh: refresh,
      color: Color(0xFFFFCB5F),
      child: FutureBuilder(
        future: _orderFuture,
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
              return orders.length != 0
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (ctx, i) =>
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF3F3C36), width: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          onLongPress: () {
                            _onButtonPressed(orders[i].id);
                          },
                          onTap: () =>
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OrderDetails(orders[i].id))),
                          dense: true,
                          selected: true,
                          leading: orders[i].status == false
                              ? Icon(Icons.clear)
                              : Icon(Icons.check),
                          title: Text(orders[i].amount.toString() + ' EGP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat-bold",
                                  fontSize: 14,
                                  color: Color(0xFF3F3C36))),
                          trailing: Text(
                            DateFormat('dd MM yyy hh:mm')
                                .format(orders[i].datetime),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 10,
                                color: Color(0xFF3F3C36)),
                          ),
                          subtitle: Text(
                            orders[i].phoneNumber,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 10,
                                color: Color(0xFF3F3C36)),
                          ),
                        ),
                      ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Image.asset(
                          "assets/images/empty-cart.png",
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 300,
                          height:
                          MediaQuery
                              .of(context)
                              .size
                              .height - 700,
                        ),
                      ),
                      Text(
                        "you haven't purchased anything yet ! ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Light",
                          fontSize: 12,
                          color: Color(0xFF3F3C36),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Container(
                child: Text(
                  "You have no orders try to buy something from our store",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontFamily: "Montserrat-Light"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
