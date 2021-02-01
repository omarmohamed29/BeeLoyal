import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loyalbee/Providers/Voucher.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AllVouchers extends StatefulWidget {
  @override
  _AllVouchersState createState() => _AllVouchersState();
}

class _AllVouchersState extends State<AllVouchers> {
  Future _voucherFuture;

  @override
  void initState() {
    _voucherFuture = getOrders();
    super.initState();
  }

  getOrders() async {
    return Provider.of<Vouchers>(context, listen: false).retrieveVoucher();
  }

  Future<String> refresh() async {
    setState(() {
      _voucherFuture = getOrders();
    });

    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    final myVoucher = Provider.of<Vouchers>(context, listen: false);
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height-450,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Text(
            "Vouchers History",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: "Montserrat-Light",
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).textTheme.headline2.color),
          ),
              myVoucher.vouchers.isNotEmpty != null ?
          Padding(
            padding: const EdgeInsets.only(top:8.0 , left: 8 , right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Text("Point", style: TextStyle(
                  fontFamily: "Montserrat-Light",
                  fontSize: 10,
                  color: Colors.grey),),
              Text("Expiry Date", style: TextStyle(
                  fontFamily: "Montserrat-Light",
                  fontSize: 10,
                  color: Colors.grey),),
                ],),
          ):Container(),
            FutureBuilder(
                future: _voucherFuture,
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
                      return myVoucher.vouchers.length != 0 ?
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: myVoucher.vouchers.length,
                          itemBuilder: (ctx, i) =>
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                Text(myVoucher.vouchers[i].points.toString(),
                                    style: TextStyle(
                                        fontFamily: "Montserrat-bold",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Theme.of(context).textTheme.headline2.color)),
                                  Text( DateFormat('dd/MM/yyy').format(myVoucher.vouchers[i].expiryDate),
                                      style: TextStyle(
                                          fontFamily: "Montserrat-Light",
                                          fontSize: 13,
                                          color: Theme.of(context).textTheme.headline2.color)),
                              ],)
                      ),
                       ) : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Opacity(
                              opacity: 0.7,
                              child: Image.asset(
                                "assets/images/coupon.png",
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width -300 ,
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height - 700,
                              ),
                            ),
                            Text(
                              "you haven't Generated any vouchers ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 12,
                                color: Theme.of(context).textTheme.headline2.color,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  }
                  return
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Opacity(
                              opacity: 0.4,
                              child: Image.asset(
                                "assets/images/coupon.png",
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width -300,
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height -700,
                              ),
                            ),
                            Text(
                              "you haven't Generated any vouchers ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 12,
                                color:Theme.of(context).textTheme.headline2.color,
                              ),
                            )
                          ],
                        ),
                      ),
                    );

                }),
          ],
          ),
        ),
      ),
    );
  }
}
