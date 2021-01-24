import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Products.dart';
import '../Screens/ProductDetails.dart';


class Suggested extends StatefulWidget {
  final String related;

  Suggested({this.related});
  @override
  _SuggestedState createState() => _SuggestedState();
}

class _SuggestedState extends State<Suggested> {
  @override
  Widget build(BuildContext context) {
    print(widget.related);
    final productsData = Provider.of<Products>(context, listen: true)
        .items
        .where((prodItem) => prodItem.subCategory.toLowerCase() == widget.related.toLowerCase())
        .toList();

    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: productsData.length,
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value: productsData[i],
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProductDetails(productsData[i].id)));
            },
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFFCB5F) , width: 0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 500,
                              width: 150,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(62, 168, 174, 201),
                                    offset: Offset(8, 9),
                                    blurRadius: 13,
                                  ),
                                ],
                              ),
                              child: Image.network(
                                productsData[i].imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 55,
                              right: 30,
                              child: Text(
                                productsData[i].title,
                                style: TextStyle(
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
