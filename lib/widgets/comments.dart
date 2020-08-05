import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Providers/Comments.dart';
import '../Providers/Rates.dart';

class CommentsList extends StatefulWidget {
  final String productId;

  CommentsList(this.productId);

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
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
    return FutureBuilder(
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
                builder: (context, getcomments, child) =>getcomments.comments.length != 0
                    ? ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: getcomments.comments.length > 3
                      ? 3
                      : getcomments.comments.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) =>  ListTile(
                          leading:
                              int.parse(getcomments.comments[i].emotion) ==
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                builder: (_, rate, ch) => RatingBarIndicator(
                                  rating: double.parse(rate.rating[i].rate),
                                  itemBuilder: (context, index) => Icon(
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
                              color: Color(0xFF3F3C36).withOpacity(0.7),
                            ),
                          ),
                        )

                ) : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            "assets/images/noComments.png",
                            width:
                            MediaQuery.of(context).size.width - 300,
                            height: MediaQuery.of(context).size.height -
                                750,
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
        });
  }
}
