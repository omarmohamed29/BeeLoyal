import 'package:flutter/material.dart';
import 'package:loyalbee/Screens/ContinueToLog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Providers/Purchase.dart';

class OrderDetails extends StatefulWidget {
  final String id;

  OrderDetails(this.id);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
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
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
            color: Colors.transparent,
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
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                        ),
                        height: MediaQuery.of(context).size.height * 50 / 100,
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
                                            DateFormat('dd MM yyy')
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
                            ],
                          ),
                        ),
                      );
                    }
                    return Text("Error Occured");
                  }
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //to retrieve data
    final orderId = widget.id;
    final ordersData =
        Provider.of<Orders>(context, listen: false).findById(orderId);
    final prod = ordersData.products;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF3F3C36),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Order Summary",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Bold",
                          fontSize: 20,
                          color: Color(0xFF3F3C36)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child: Stepper(
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Container();
                },
                steps: [
                  Step(
                    title: Text(
                      "Order Placed on  " +
                          DateFormat('dd MM yyy').format(ordersData.datetime),
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
                    isActive: ordersData.status == true ? true : false,
                    state: ordersData.status == true
                        ? StepState.complete
                        : StepState.error,
                  )
                ],
                currentStep: ordersData.status == true ? 2 : 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Text("Order Details",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Bold",
                      fontSize: 20,
                      color: Color(0xFF3F3C36))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Order Id : " + orderId,
                  style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 12,
                      color: Color(0xFF3F3C36))),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: ordersData.products.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(prod[i].title,
                            style: TextStyle(
                                fontFamily: "Montserrat-light",
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF3F3C36))),
                        Text('${prod[i].quantity}x ${prod[i].price}  EGP',
                            style: TextStyle(
                                fontFamily: "Montserrat-light",
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF3F3C36))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width - 40,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total : ",
                      style: TextStyle(
                          fontFamily: "Montserrat-Bold",
                          fontSize: 12,
                          color: Color(0xFF3F3C36))),
                  Text(ordersData.amount.toString() + " EGP",
                      style: TextStyle(
                          fontFamily: "Montserrat-Bold",
                          fontSize: 12,
                          color: Color(0xFF3F3C36)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
