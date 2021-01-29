import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Providers/QrScanner.dart';
import '../Providers/WalletManager.dart';

class QrScan extends StatefulWidget {
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String barcode = "";

  void wrongQr(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: "Got it",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      barcode.contains('BeelQR01474774658')
          ? setState(() => this.barcode = barcode)
          : wrongQr("Please Scan The Verified Bee Loyal QR Code");
      if (barcode.contains('BeelQR01474774658')) {
        Provider.of<WalletManager>(context, listen: false).retrieveWallet();
        final money =
            Provider.of<WalletManager>(context, listen: false).wallet[0].money;
        final id =
            Provider.of<WalletManager>(context, listen: false).wallet[0].id;
        final pointsInWallet =
            Provider.of<WalletManager>(context, listen: false).wallet[0].points;
        final points = pointsInWallet +
            int.parse(barcode.replaceAll('BeelQR01474774658', ''));
        final pointUpdater = Provider.of<GetPoints>(context, listen: false);
        await pointUpdater.scanForPoints(
            int.parse(barcode.replaceAll('BeelQR01474774658', '')));
        await pointUpdater.updatePoints(money, id, points);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        wrongQr("Please Scan The Verified Bee Loyal QR Code");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        wrongQr("Please Scan The Verified Bee Loyal QR Code");
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                      color: Theme.of(context).textTheme.headline2.color,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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
                  'Get',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat-Bold",
                    fontSize: 40,
                    color: Color(0xFFFFCB5F),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: 100,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Points',
                  style: TextStyle(
                      fontFamily: "Montserrat-Light",
                      fontSize: 40,
                      color: Theme.of(context).textTheme.headline2.color),
                ),
              ),
            ),
            Positioned(
              top: 220,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () async {
                  scan();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Scan for points",
                          style: TextStyle(
                              fontFamily: "Montserrat-Light",
                              fontSize: 20,
                              color:
                                  Theme.of(context).textTheme.headline2.color),
                        ),
                        Icon(
                          Icons.camera,
                          color: Theme.of(context).textTheme.headline2.color,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              left: 20,
              right: 20,
              child: Container(
                height: 500,
                child: Card(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text("Previous Scans",
                          style: TextStyle(
                              fontFamily: "Montserrat-Light",
                              fontSize: 25,
                              color: Color(0xFFFFCB5F),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: Provider.of<GetPoints>(context, listen: false)
                            .retrieveQrs(),
                        builder: (ctx, dataSnapshot) {
                          if (dataSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: SpinKitWave(
                              color: Color(0xFFFFCB5F),
                              type: SpinKitWaveType.start,
                              size: 12,
                            ));
                          } else {
                            if (dataSnapshot.error != null) {
                              Center(
                                child: Text('An error occured'),
                              );
                            } else {
                              return (Consumer<GetPoints>(
                                  builder: (_, qr, ch) => ListView.builder(
                                      itemCount: qr.qrs.length,
                                      itemBuilder: (ctx, i) => Container(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons.qr_code_scanner,
                                                      color: Color(0xFFFFCB5F),
                                                    ),
                                                    title: Text(
                                                      qr.qrs[i].points
                                                          .toString() +
                                                          " Points",
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily:
                                                        "Montserrat-Light",
                                                        fontSize: 18,
                                                        color: Theme.of(context).textTheme.headline2.color,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      DateFormat(
                                                          "dd-MM-yyy  hh:mm")
                                                          .format(qr.qrs[i].date),
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily:
                                                        "Montserrat-Light",
                                                        fontSize: 8,
                                                        color: Theme.of(context).textTheme.headline2.color,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))));
                            }
                            return Container(
                              child: Center(
                                child: Text(
                                  "You don't have any scans yet ",
                                  style: TextStyle(
                                      fontFamily: "Montserrat-Light",
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .color),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )),
              ),
            )
          ],
        ));
  }
}
