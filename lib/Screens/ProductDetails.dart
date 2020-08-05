import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loyalbee/Providers/Offers.dart';
import 'package:loyalbee/Providers/Rates.dart';
import 'package:loyalbee/Screens/AllComments.dart';
import 'package:loyalbee/widgets/MakeComment.dart';
import 'package:loyalbee/widgets/SuggestedProd.dart';
import '../widgets/comments.dart';
import '../widgets/details_icons.dart';
import 'package:provider/provider.dart';
import '../Providers/Products.dart';
import '../Providers/Cart.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/Product-Detail';
  final String id;

  ProductDetails(this.id);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future _rateFuture;

  getRates() async {
    return await Provider.of<Rating>(context, listen: false)
        .retrieveRate(widget.id);
  }

  @override
  void initState() {
    _rateFuture = getRates();
    super.initState();
  }

  void itemAdded() {
    final String loadedId = widget.id;
    final cart = Provider.of<Cart>(context, listen: false);
    final snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Text("Item Added to card"),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.black.withOpacity(0.9),
      action: SnackBarAction(
        label: "undo",
        onPressed: () {
          cart.removeSingleItem(loadedId);
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    //to retrieve data
    final productId = widget.id;
    final loadedProducts =
    Provider.of<Products>(context, listen: false).findById(productId);
    final sizes = loadedProducts.sizes[0];
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250,
            elevation: 2.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                loadedProducts.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: loadedProducts.description.length + 650.toDouble(),
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: Colors.white,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 15, left: 15),
                                child: Text(
                                  loadedProducts.title,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: "Montserrat-Light",
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3F3C36)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 15.0, right: 15),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Details.price,
                                    size: 26,
                                    color: Color(0xFFFFCB5F),
                                  ),
                                  FutureBuilder(
                                      future: Provider.of<Offers>(context,
                                          listen: false)
                                          .retrieveOffer(),
                                      builder: (ctx, dataSnapshot) {
                                        if (dataSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: SpinKitCircle(
                                                color: Color(0xFFFFCB5F),
                                                size: 5,
                                              ));
                                        } else {
                                          if (dataSnapshot.error != null) {
                                            Center(
                                              child: Text('An error occured'),
                                            );
                                          } else {
                                            return Consumer<Offers>(
                                              builder: (_, offer, ch) =>
                                              offer
                                                  .offers[0] !=
                                                  null &&
                                                  offer.offers[0].dueDate
                                                      .day -
                                                      DateTime
                                                          .now()
                                                          .day >
                                                      0 &&
                                                  offer.offers[0].dueDate
                                                      .month ==
                                                      DateTime
                                                          .now()
                                                          .month &&
                                                  offer.offers[0].dueDate
                                                      .year ==
                                                      DateTime
                                                          .now()
                                                          .year
                                                  ? Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      loadedProducts.price
                                                          .toString(),
                                                      style: TextStyle(
                                                          decoration: TextDecoration
                                                              .lineThrough,
                                                          decorationColor:
                                                          Colors
                                                              .redAccent,
                                                          fontSize: 15,
                                                          fontFamily:
                                                          "Montserrat-Light",
                                                          color: Color(
                                                              0xFF3F3C36)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      offer
                                                          .offerCalculate(
                                                          loadedProducts
                                                              .price)
                                                          .toStringAsFixed(
                                                          2) +
                                                          "EGP",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontFamily:
                                                          "Montserrat-Light",
                                                          color: Color(
                                                              0xFF3F3C36)),
                                                    ),
                                                  ),
                                                ],
                                              )
                                                  : Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  loadedProducts.price
                                                      .toString() +
                                                      " EGP",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontFamily:
                                                      "Montserrat-Light",
                                                      color: Color(
                                                          0xFF3F3C36)),
                                                ),
                                              ),
                                            );
                                          }
                                          return Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              loadedProducts.price.toString(),
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily:
                                                  "Montserrat-Light",
                                                  color: Color(0xFF3F3C36)),
                                            ),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0, left: 15),
                          child: FutureBuilder(
                              future: _rateFuture,
                              builder: (ctx, dataSnapshot) {
                                if (dataSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: SpinKitCircle(
                                        color: Color(0xFFFFCB5F),
                                        size: 2,
                                      ));
                                } else {
                                  if (dataSnapshot.error != null) {
                                    Center(
                                      child: Text('An error occured'),
                                    );
                                  } else {
                                    return Consumer<Rating>(
                                      builder: (_, rate, ch) =>
                                      rate
                                          .average() !=
                                          0
                                          ? Row(
                                        children: <Widget>[
                                          Center(
                                            child: RatingBarIndicator(
                                              rating: double.parse(rate
                                                  .average()
                                                  .toString()),
                                              itemBuilder:
                                                  (context, index) =>
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xFFFFCB5F),
                                                  ),
                                              itemCount: 4,
                                              itemSize: 10.0,
                                              direction: Axis.horizontal,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 2.0),
                                            child: Text(
                                                rate
                                                    .average()
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontFamily:
                                                    "Montserrat-Light",
                                                    fontSize: 10,
                                                    color: Color(
                                                        0xFF3F3C36))),
                                          )
                                        ],
                                      )
                                          : Container(),
                                    );
                                  }
                                }
                                return Container();
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 8),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  loadedProducts.description,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Montserrat-Light",
                                      color: Color(0xFF3F3C36)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Color",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  ),
                                  Text(
                                    loadedProducts.color,
                                    style: TextStyle(
                                      color: Color(0xFF3F3C36),
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Brand",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  ),
                                  Text(
                                    loadedProducts.brand,
                                    style: TextStyle(
                                      color: Color(0xFF3F3C36),
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  ),
                                  Text(
                                    loadedProducts.category,
                                    style: TextStyle(
                                      color: Color(0xFF3F3C36),
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Available",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  ),
                                    loadedProducts.inStock == 0 ?
                                    Text("Out of Stock", style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),)
                                        :
                                    Text(loadedProducts.inStock.toString(),
                                    style: TextStyle(
                                      color: Color(0xFF3F3C36),
                                      fontSize: 15,
                                      fontFamily: "Montserrat-Light",
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 8.0, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Comments & Reviews",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Montserrat-Light",
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3F3C36)),
                                  ),
                                  MakeComment(productId),
                                ],
                              ),
                              CommentsList(productId),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  "View All Comments",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFFFCB5F),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat-Light"),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AllComments(
                                            productId: loadedProducts.id,
                                          )));
                                },
                              ),
                              Text(
                                "Suggested for you",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Montserrat-Light",
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3F3C36)),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                  height: 150,
                                  child: Suggested(
                                    related: loadedProducts.subCategory,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Builder(builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child:
          loadedProducts.subCategory.toLowerCase() == "watches" ||
              loadedProducts.subCategory.toLowerCase() == "wallets" ?
          RaisedButton(
              color: Color(0xFFFFCB5F),
              textColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Add to shopping cart',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat-Bold",
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed:
              loadedProducts.inStock > 0 ?
                  () async {
                final offer = Provider.of<Offers>(context, listen: false);
                cart.addItem(
                    loadedProducts.id,
                    offer.offers[0] != null &&
                        offer.offers[0].dueDate.day - DateTime
                            .now()
                            .day >
                            0 &&
                        offer.offers[0].dueDate.month ==
                            DateTime
                                .now()
                                .month &&
                        offer.offers[0].dueDate.year == DateTime
                            .now()
                            .year &&
                        offer.offerCalculate(loadedProducts.price) != null
                        ? offer.offerCalculate(loadedProducts.price)
                        : loadedProducts.price,
                    loadedProducts.title,
                    loadedProducts.imageUrl);
                await Provider.of<Products>(context, listen: false).updateProd(
                    loadedProducts.id,
                    loadedProducts.title,
                    loadedProducts.description,
                    loadedProducts.price,
                    loadedProducts.imageUrl,
                    loadedProducts.color,
                    loadedProducts.brand,
                    loadedProducts.category,
                    loadedProducts.subCategory,
                    loadedProducts.hits + 1,
                    loadedProducts.inStock-1);
                itemAdded();
              } : null
          ) : RaisedButton(
              color: Color(0xFFFFCB5F),
              textColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Add to shopping cart',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat-Bold",
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed:
              loadedProducts.inStock > 0 ?
                  () {
                Scaffold.of(context).showBottomSheet(
                      (context) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey[300],
                                    spreadRadius: 5)
                              ]),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 45 / 160,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 30, bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Select a size",
                                  style: TextStyle(
                                      fontFamily: "Montserrat-bold",
                                      fontSize: 20,
                                      color: Color(0xFF3F3C36)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: RaisedButton(
                                          color: Color(0xFFFFCB5F),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: Text(
                                            "S",
                                            style: TextStyle(
                                                fontFamily: "Montserrat-bold",
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onPressed: sizes.small
                                              .toLowerCase() ==
                                              "true"
                                              ? () async {
                                            final offer = Provider.of<Offers>(
                                                context,
                                                listen: false);
                                            cart.addItem(
                                                loadedProducts.id,
                                                offer.offers[0] != null &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .day -
                                                        DateTime
                                                            .now()
                                                            .day >
                                                        0 &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .month ==
                                                        DateTime
                                                            .now()
                                                            .month &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .year ==
                                                        DateTime
                                                            .now()
                                                            .year &&
                                                    offer.offerCalculate(
                                                        loadedProducts
                                                            .price) !=
                                                        null
                                                    ? offer.offerCalculate(
                                                    loadedProducts.price)
                                                    : loadedProducts.price,
                                                loadedProducts.title,
                                                loadedProducts.imageUrl);
                                            await Provider.of<Products>(
                                                context,
                                                listen: false)
                                                .updateProd(
                                                loadedProducts.id,
                                                loadedProducts.title,
                                                loadedProducts
                                                    .description,
                                                loadedProducts.price,
                                                loadedProducts.imageUrl,
                                                loadedProducts.color,
                                                loadedProducts.brand,
                                                loadedProducts.category,
                                                loadedProducts
                                                    .subCategory,
                                                loadedProducts.hits + 1,
                                                loadedProducts.inStock-1);
                                            Navigator.of(context).pop();
                                            itemAdded();
                                            // Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>ShoppingCart()));
                                          }
                                              : null,
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: RaisedButton(
                                          color: Color(0xFFFFCB5F),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: Text(
                                            "M",
                                            style: TextStyle(
                                                fontFamily: "Montserrat-bold",
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onPressed: sizes.medium
                                              .toLowerCase() ==
                                              "true"
                                              ? () async {
                                            final offer = Provider.of<Offers>(
                                                context,
                                                listen: false);
                                            cart.addItem(
                                                loadedProducts.id,
                                                offer.offers[0] != null &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .day -
                                                        DateTime
                                                            .now()
                                                            .day >
                                                        0 &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .month ==
                                                        DateTime
                                                            .now()
                                                            .month &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .year ==
                                                        DateTime
                                                            .now()
                                                            .year &&
                                                    offer.offerCalculate(
                                                        loadedProducts
                                                            .price) !=
                                                        null
                                                    ? offer.offerCalculate(
                                                    loadedProducts.price)
                                                    : loadedProducts.price,
                                                loadedProducts.title,
                                                loadedProducts.imageUrl);
                                            await Provider.of<Products>(
                                                context,
                                                listen: false)
                                                .updateProd(
                                                loadedProducts.id,
                                                loadedProducts.title,
                                                loadedProducts
                                                    .description,
                                                loadedProducts.price,
                                                loadedProducts.imageUrl,
                                                loadedProducts.color,
                                                loadedProducts.brand,
                                                loadedProducts.category,
                                                loadedProducts
                                                    .subCategory,
                                                loadedProducts.hits + 1,
                                                loadedProducts.inStock
                                            );
                                            await Future.delayed(
                                                Duration(milliseconds: 100));
                                            Navigator.of(context).pop();
                                            itemAdded();
                                          }
                                              : null,
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: RaisedButton(
                                          color: Color(0xFFFFCB5F),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: Text(
                                            "L",
                                            style: TextStyle(
                                                fontFamily: "Montserrat-bold",
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onPressed: sizes.large
                                              .toLowerCase() ==
                                              "true"
                                              ? () async {
                                            final offer = Provider.of<Offers>(
                                                context,
                                                listen: false);
                                            cart.addItem(
                                                loadedProducts.id,
                                                offer.offers[0] != null &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .day -
                                                        DateTime
                                                            .now()
                                                            .day >
                                                        0 &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .month ==
                                                        DateTime
                                                            .now()
                                                            .month &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .year ==
                                                        DateTime
                                                            .now()
                                                            .year &&
                                                    offer.offerCalculate(
                                                        loadedProducts
                                                            .price) !=
                                                        null
                                                    ? offer.offerCalculate(
                                                    loadedProducts.price)
                                                    : loadedProducts.price,
                                                loadedProducts.title,
                                                loadedProducts.imageUrl);
                                            await Provider.of<Products>(
                                                context,
                                                listen: false)
                                                .updateProd(
                                                loadedProducts.id,
                                                loadedProducts.title,
                                                loadedProducts
                                                    .description,
                                                loadedProducts.price,
                                                loadedProducts.imageUrl,
                                                loadedProducts.color,
                                                loadedProducts.brand,
                                                loadedProducts.category,
                                                loadedProducts
                                                    .subCategory,
                                                loadedProducts.hits + 1,
                                                loadedProducts.inStock);
                                            await Future.delayed(
                                                Duration(milliseconds: 100));
                                            Navigator.of(context).pop();
                                            itemAdded();
                                          }
                                              : null,
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: RaisedButton(
                                          color: Color(0xFFFFCB5F),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: Text(
                                            "XL",
                                            style: TextStyle(
                                                fontFamily: "Montserrat-bold",
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onPressed: sizes.xLarge
                                              .toLowerCase() ==
                                              "true"
                                              ? () async {
                                            final offer = Provider.of<Offers>(
                                                context,
                                                listen: false);
                                            cart.addItem(
                                                loadedProducts.id,
                                                offer.offers[0] != null &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .day -
                                                        DateTime
                                                            .now()
                                                            .day >
                                                        0 &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .month ==
                                                        DateTime
                                                            .now()
                                                            .month &&
                                                    offer
                                                        .offers[0]
                                                        .dueDate
                                                        .year ==
                                                        DateTime
                                                            .now()
                                                            .year &&
                                                    offer.offerCalculate(
                                                        loadedProducts
                                                            .price) !=
                                                        null
                                                    ? offer.offerCalculate(
                                                    loadedProducts.price)
                                                    : loadedProducts.price,
                                                loadedProducts.title,
                                                loadedProducts.imageUrl);
                                            await Provider.of<Products>(
                                                context,
                                                listen: false)
                                                .updateProd(
                                                loadedProducts.id,
                                                loadedProducts.title,
                                                loadedProducts
                                                    .description,
                                                loadedProducts.price,
                                                loadedProducts.imageUrl,
                                                loadedProducts.color,
                                                loadedProducts.brand,
                                                loadedProducts.category,
                                                loadedProducts
                                                    .subCategory,
                                                loadedProducts.hits + 1,
                                                loadedProducts.inStock);
                                            await Future.delayed(
                                                Duration(milliseconds: 100));
                                            Navigator.of(context).pop();
                                            itemAdded();
                                          }
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                );
              } : null),
        );
      }),
    );
  }
}
