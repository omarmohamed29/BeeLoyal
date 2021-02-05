import 'package:flutter/material.dart';
import '../Providers/Products.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ProductDetails.dart';

class ProductSearch extends SearchDelegate<Products> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productsName = Provider.of<Products>(context, listen: false);
    final result = productsName.items
        .where((prodItem) => prodItem.title.toLowerCase().contains(query))
        .toList();
    return FutureBuilder(
      future: Provider.of<Products>(context, listen: false).fetchProducts(),
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: result.length,
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(result[i].imageUrl),
                                fit: BoxFit.cover)),
                      ),
                      title: Text(
                        result[i].title,
                        style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 14,
                            color: Theme.of(context).textTheme.headline2.color),
                      ),
                      subtitle: Text(
                        "Available : " + result[i].inStock.toString(),
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontSize: 10,
                            color: Theme.of(context).textTheme.headline2.color),
                      ),
                      trailing: Text(
                        result[i].price.toString() + " EGP",
                        style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            fontSize: 10,
                            color: Theme.of(context).textTheme.headline2.color),
                      ),
                      onTap: () {
                        close(context, productsName);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProductDetails(result[i].id)));
                      },
                    );
                  }),
            );
          }
        }
        return Center(
          child: Text("I have no products"),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productsName = Provider.of<Products>(context, listen: false);
    final result = productsName.items
        .where((prodItem) => prodItem.title.toLowerCase().contains(query))
        .toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            child: Icon(
              Icons.search,
              size: 100,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        Center(
            child: Text(
          'Looking for something ? ',
          style: TextStyle(
              fontFamily: "Montserrat-Bold",
              fontSize: 20,
              color: Theme.of(context).textTheme.headline2.color),
        ))
      ],
    );
  }
}
