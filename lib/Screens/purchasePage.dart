import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/PurchaseCard.dart';

// ignore: must_be_immutable
class PurchasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Orders",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat-Bold",
                fontSize: 30,
                color: Color(0xFF3F3C36)),
          ),
          bottom: TabBar(
            indicatorColor: Color(0xFFFFCB5F),
            dragStartBehavior: DragStartBehavior.start,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "New",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
                ),
              ),
              Tab(
                child: Text(
                  "Delivered",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
                ),
              ),
              Tab(
                child: Text(
                  "All",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat-Light",
                      fontSize: 15,
                      color: Color(0xFF3F3C36)),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PurchaseCard(status: false),
            PurchaseCard(status: true),
            PurchaseCard(),
          ],
        ),
      ),
    );
  }
}
