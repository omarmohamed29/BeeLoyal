import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loyalbee/Screens/PdfViewScreen.dart';
import 'package:loyalbee/widgets/Allvouchers.dart';
import 'package:loyalbee/widgets/profile_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../Providers/Voucher.dart';
import '../Providers/WalletManager.dart';

// ignore: must_be_immutable
class VoucherPage extends StatefulWidget {
  static const routeName = '/VoucherPage';

  @override
  _VoucherPageState createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final pdf = pw.Document();

  int points = 0;

//  Future<int> pointSet(point) async {
//    print(point);
//    return points = point;
//  }

  Future _voucherFuture;
  Future _walletFuture;
  bool _isLoading = false;
  String fullPath = "";
  getVoucher() async {
    await Provider.of<Vouchers>(context, listen: false).retrieveVoucher();
  }

  getWallet() async {
    await Provider.of<WalletManager>(context, listen: false).retrieveWallet();
  }

  @override
  void initState() {
    _voucherFuture = getVoucher();
    _walletFuture = getWallet();
    super.initState();
  }

  Future<String> refresh() async {
    setState(() {
      _voucherFuture = getVoucher();
      _walletFuture = getWallet();
    });
    return  "done";
  }

  void noPoints() {
    final snackbar = SnackBar(
      content: Text(
        "Please enter some points or check that you have points",
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
    );

    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void nothing(){
  }

  generateVouchers(int points) async {
    var fontData = await rootBundle.load("assets/fonts/Montserrat-Light.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    final userName = ModalRoute.of(context).settings.arguments as String;
    final voucherData =
        Provider.of<Vouchers>(context, listen: false).vouchers[0];
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.only(left: 25, right: 25, top: 20),
        build: (pw.Context context ) {
          return <pw.Widget>[
            pw.Header(level: 0, child: pw.Text("Bee Loyal App Voucher")),
            pw.Paragraph(
              text: "This is A voucher from : bee loyal",
            ),
            pw.Paragraph(
              text: "This is a voucher presented to Client : $userName",
            ),
            pw.Center(
              child: pw.Paragraph(
                text: "The Generated amount of points are : " +
                    voucherData.points.toString(),
                style: pw.TextStyle(font: ttf, fontSize: 25),
              ),
            ),
            pw.Padding(
                padding: pw.EdgeInsets.only(left: 100),
                child: pw.Row(children: [
                  pw.Paragraph(
                    text: "Voucher id : " + voucherData.id,
                  ),
                  pw.Paragraph(
                    padding: pw.EdgeInsets.only(left: 20),
                    text: "Expiry date : " +
                        DateFormat('dd/MM/yyy').format(voucherData.expiryDate),
                  ),
                ])),
            pw.Center(
              child: pw.Paragraph(
                text:
                    "You can find this voucher in 'PhoneStorage/android/com.example.loyalbee/files/voucher.pdf'",
              ),
            ),
            pw.Center(
              child: pw.Paragraph(
                text: "Or you can just take it as screenShot",
              ),
            ),
            pw.Center(
              child: pw.Paragraph(
                text:
                    "Give the voucher to any beeloyal branches and you can use it immediately",
              ),
            )
          ];
        }));
  }

  Future savePdf() async {
    Directory documentDirectory = await getExternalStorageDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/Voucher.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context).settings.arguments as String;
    final myPoints =
        Provider.of<WalletManager>(context, listen: false).wallet[0];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back,
                  color:Theme.of(context).textTheme.headline2.color,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Get',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat-Bold",
                    fontSize: 40,
                    color: Theme.of(context).textTheme.headline2.color),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Vouchers',
                style: TextStyle(
                    fontFamily: "Montserrat-Light",
                    fontSize: 40,
                    color: Theme.of(context).textTheme.headline2.color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xFFFFCB5F).withOpacity(0.9),
                ),
                height: 180,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Amount of points",
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: 100.0,
                        child:
                        _isLoading  ?
                            SpinKitCircle(
                              color: Colors.white,
                              size: 12,
                            )
                            :
                        TextField(
                          enableInteractiveSelection: false,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (input) async {
                            setState(() {
                              points = int.parse(input);
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Points",
                              hintStyle: TextStyle(
                                  color: Colors.white, fontSize: 12.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 60, right: 60),
                      child: FlatButton(
                        onPressed: points > 0
                            ? () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  myPoints.points >= points && _isLoading == true?
                                await Provider.of<Vouchers>(context,
                                        listen: false)
                                    .addVoucher(bool.fromEnvironment("0"),
                                        points, userName) : noPoints();

                                myPoints.points >= points  && _isLoading == true
                                    ? await Provider.of<WalletManager>(context,
                                            listen: false)
                                        .voucherMoney(points)
                                    : nothing();
                                final walletData = Provider.of<WalletManager>(
                                        context,
                                        listen: false)
                                    .wallet[0]
                                    .id;
                                myPoints.points >= points && _isLoading == true
                                    ? await Provider.of<WalletManager>(context,
                                            listen: false)
                                        .updateWallet(walletData)
                                    :  nothing();

                                myPoints.points >= points && _isLoading == true
                                    ? generateVouchers(points)
                                    : nothing();

                                myPoints.points >= points && _isLoading == true
                                    ? await savePdf()
                                    : nothing();

                                if(myPoints.points >= points && _isLoading == true){
                                  Directory documentDirectory =
                                  await getExternalStorageDirectory();
                                  String documentPath = documentDirectory.path;
                                  fullPath = "${documentPath}/Voucher.pdf";
                                }else{
                                  nothing();
                                }
                                if(myPoints.points >= points && _isLoading == true){
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PdfViewScreen(path: fullPath)));
                                }else{
                                  nothing();
                                }
                                  refresh();
                                  setState(() {
                                    _isLoading = false;
                                    points = 0;
                                  });
                              }
                            : () => noPoints(),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(
                                "Get Voucher",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat-Light",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 3),
                              child: Icon(Profile.vouchers,
                                  size: 25, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AllVouchers(),
          ],
        ),
      ),
    );
  }
}
