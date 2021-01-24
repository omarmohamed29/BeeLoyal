import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../models/Product.dart';
import '../Screens/ProductDetails.dart';
import 'FavouriteIcon.dart';

class ProductItem extends StatelessWidget {
  final String id;

//
//  final String title;
//  final String imageUrl;
//
  ProductItem(this.id);

//  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return Container(
      decoration:Theme.of(context).backgroundColor ==  Color(0xFF111111) ? null :  BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(62, 168, 174, 201),
            offset: Offset(8, 9),
            blurRadius: 13,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 6.0, right: 6.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ProductDetails(id)));
            },
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black45.withOpacity(0.3)
                        ],
                        stops: [0, 100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 5,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: product.title,
                                style: TextStyle(fontSize: 22))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 5,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            product.price.toString(),
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "EGP",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 1.0),
                      child: FavIcon(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
