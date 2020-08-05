import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Providers/Comments.dart';
import '../Providers/Rates.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';


class AllComments extends StatefulWidget {
  final String productId;

  AllComments({this.productId});

  @override
  _AllCommentsState createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  Future _ratingFuture;

  getRating() async {
    return await Provider.of<Rating>(context, listen: false)
        .retrieveRate(widget.productId);
  }

  @override
  void initState() {
    _ratingFuture = getRating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Comments And Reviews",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat-Light",
              fontSize: 20,
              color: Color(0xFF3F3C36)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
                future: _ratingFuture,
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SpinKitCircle(
                          color: Color(0xFFFFCB5F),
                          size: 15,
                        ),
                      ),
                    );
                  } else {
                    if (dataSnapshot.error != null) {
                      Center(
                        child: Text('An error occured'),
                      );
                    } else {
                      return Consumer<Rating>(
                        builder: (_, rate, ch) =>
                        rate.average() != 0 ? Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    rate
                                        .average()
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontFamily:
                                        "Montserrat-Light",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                        color:
                                        Color(0xFF3F3C36))),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: RatingBarIndicator(
                                    rating: double.parse(rate
                                        .average()
                                        .toString()),
                                    itemBuilder:
                                        (context, index) =>
                                        Icon(
                                          Icons.star,
                                          color: Color(
                                              0xFFFFCB5F),
                                        ),
                                    itemCount: 4,
                                    itemSize: 18,
                                    direction: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0 ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right:3.0 ),
                                        child: Text(
                                            "4",
                                            style: TextStyle(
                                                fontFamily:
                                                "Montserrat-Light",
                                                fontSize: 10,
                                                color:
                                                Color(0xFF3F3C36))),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width-150,
                                        child: FAProgressBar(
                                          currentValue: rate.total(4).toInt(),
                                          maxValue: 20,
                                          progressColor: Color(0xFFFFCB5F),
                                          size: 8,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right:3.0 ),
                                        child: Text(
                                            "3",
                                            style: TextStyle(
                                                fontFamily:
                                                "Montserrat-Light",
                                                fontSize: 10,
                                                color:
                                                Color(0xFF3F3C36))),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width-150,
                                        child: FAProgressBar(
                                          maxValue: 20,
                                          progressColor: Color(0xFFFFCB5F),
                                          currentValue: rate.total(3).toInt(),
                                          size: 8,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right:3.0 ),
                                        child: Text(
                                            "2",
                                            style: TextStyle(
                                                fontFamily:
                                                "Montserrat-Light",
                                                fontSize: 10,
                                                color:
                                                Color(0xFF3F3C36))),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width-150,
                                        child: FAProgressBar(
                                          maxValue: 20,
                                          progressColor: Color(0xFFFFCB5F),
                                          currentValue: rate.total(2).toInt(),
                                          size: 8,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right:3.0 ),
                                        child: Text(
                                            "1",
                                            style: TextStyle(
                                                fontFamily:
                                                "Montserrat-Light",
                                                fontSize: 10,
                                                color:
                                                Color(0xFF3F3C36))),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width-150,
                                        child: FAProgressBar(
                                          maxValue: 20,
                                          progressColor: Color(0xFFFFCB5F),
                                          currentValue:rate.total(1).toInt(),
                                          size: 8,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) : Container(),
                      );
                    }
                  }
                  return Container();
                }),
            Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: FutureBuilder(
                  future: Provider.of<Comments>(context, listen: false)
                      .retrieveComment(widget.productId),
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SpinKitCircle(
                            color: Color(0xFFFFCB5F),
                            size: 15,
                          ),
                        ),
                      );
                    } else {
                      if (dataSnapshot.error != null) {
                        Center(
                          child: Text('An error occured'),
                        );
                      } else {
                        return Consumer<Comments>(
                          builder: (context, getcomments, child) => getcomments
                                      .comments.length !=
                                  0
                              ? ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemCount: getcomments.comments.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, i) => ListTile(
                                        leading:   int.parse(getcomments.comments[i].emotion) ==
                                            4
                                            ? Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Color(0xFF3F3C36),
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Color(0xFF3F3C36),
                                                size: 20,
                                              ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              getcomments.comments[i].name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat-Light",
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3F3C36),
                                              ),
                                            ),
                                            Consumer<Rating>(
                                              builder: (_, rate, ch) =>
                                                  RatingBarIndicator(
                                                rating: double.parse(
                                                    rate.rating[i].rate),
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Color(0xFFFFCB5F),
                                                ),
                                                itemCount: 4,
                                                itemSize: 10.0,
                                                direction: Axis.horizontal,
                                              ),
                                            )
                                          ],
                                        ),
                                        subtitle: Text(
                                          getcomments.comments[i].body,
                                          style: TextStyle(
                                            fontFamily: "Montserrat-Light",
                                            color:
                                                Color(0xFF3F3C36).withOpacity(0.7),
                                          ),
                                        ),
                                      ))
                              : Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Opacity(
                                          opacity: 0.2,
                                          child: Image.asset(
                                            "assets/images/noComments.png",
                                            width:
                                                MediaQuery.of(context).size.width -
                                                    300,
                                            height:
                                                MediaQuery.of(context).size.height -
                                                    750,
                                          ),
                                        ),
                                        Text(
                                          "This product has no reviews , be the first",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat-Light",
                                            fontSize: 10,
                                            color:
                                                Color(0xFF3F3C36).withOpacity(0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        );
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Opacity(
                              opacity: 0.2,
                              child: Image.asset(
                                "assets/images/noComments.png",
                                width: MediaQuery.of(context).size.width - 300,
                                height: MediaQuery.of(context).size.height - 750,
                              ),
                            ),
                            Text(
                              "This product has no reviews , be the first",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-Light",
                                fontSize: 10,
                                color: Color(0xFF3F3C36).withOpacity(0.4),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
