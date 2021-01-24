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


  @override
  Widget build(BuildContext context) {
    //to retrieve data
    final orderId = widget.id;
    final ordersData =
        Provider.of<Orders>(context, listen: false).findById(orderId);
    final prod = ordersData.products;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Order Summary",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat-Bold",
              fontSize: 20,
              color: Theme.of(context).textTheme.headline2.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text(
              "Follow your orders and get detailed information about the delivery steps",
              style: TextStyle(
                  fontFamily: "Montserrat-Light",
                  fontSize: 8,
                  color: Theme.of(context).textTheme.headline2.color),
              textAlign: TextAlign.center,
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
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width - 200,
              color: Color(0xFFFFCB5F),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text("Order Details",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 18,
                      color: Theme.of(context).textTheme.headline2.color)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Order Id : " + orderId,
                  style: TextStyle(
                      fontFamily: "Montserrat-Light",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                      Theme.of(context).textTheme.headline2.color)),
            ),
            Card(
              child: ListView.builder(
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color)),
                          Text('${prod[i].quantity}x ${prod[i].price}  EGP',
                              style: TextStyle(
                                  fontFamily: "Montserrat-light",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total : ",
                        style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 12,
                            color: Theme.of(context).textTheme.headline2.color)),
                    Text(ordersData.amount.toString() + " EGP",
                        style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 12,
                            color: Theme.of(context).textTheme.headline2.color))
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
