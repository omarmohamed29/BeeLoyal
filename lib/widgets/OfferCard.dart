import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'profile_icons.dart';
import '../Providers/Offers.dart';

class OfferCard extends StatefulWidget {
  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  Future _offersFuture;

  getOffers() async {
    return await Provider.of<Offers>(context, listen: false).retrieveOffer();
  }

  void initState() {
    _offersFuture = getOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _offersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(200),
              child: Center(
                  child: SpinKitCircle(
                color: Color(0xFFFFCB5F),
                size: 12,
              )),
            );
          } else {
            if (dataSnapshot.error != null) {
              Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<Offers>(
                  builder: (_, offer, ch) => offer.offers[0] != null &&
                          offer.offers[0].dueDate.day - DateTime.now().day >
                              0 &&
                          offer.offers[0].dueDate.month == DateTime.now().month
                              &&
                          offer.offers[0].dueDate.year  == DateTime.now().year
                      ? Column(
                          children: <Widget>[
                            Icon(
                              Profile.offers,
                              color: Color(0xFFFFCB5F),
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(offer.offers[0].title,
                                  style: TextStyle(
                                    color:  Color(0xFFFFCB5F),
                                    fontFamily: "Montserrat-Light",
                                    fontSize: 10,
                                  )),
                            ),
                            Text(
                              offer.offers[0].description,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.headline2.color,
                                fontFamily: "Montserrat-Light",
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  "Expires in : " +
                                      DateFormat('dd/MM/yyy')
                                          .format(offer.offers[0].dueDate),
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.headline2.color,
                                    fontFamily: "Montserrat-Light",
                                    fontSize: 10,
                                  )),
                            ),
                          ],
                        )
                      : Container());
            }
            return Container();
          }
        },
      ),
    );
  }
}
