import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavouriteIcon.dart';
import '../Providers/Products.dart';
import '../Screens/ProductDetails.dart';

class CategoriesViewer extends StatefulWidget {
  final String subCategory;
  final bool showFavs;

  CategoriesViewer(this.subCategory, this.showFavs);

  @override
  _CategoriesViewerState createState() => _CategoriesViewerState();
}

class _CategoriesViewerState extends State<CategoriesViewer> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true)
        .items
        .where((prodItem) => prodItem.subCategory.toLowerCase() == widget.subCategory.toLowerCase())
        .toList();

    final prodData = Provider.of<Products>(context, listen: true);
    final products = widget.showFavs
        ? prodData.favouriteItems
            .where((prodItem) => prodItem.subCategory.toLowerCase() == widget.subCategory.toLowerCase())
            .toList()
        : productsData;
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: Container(
          decoration: BoxDecoration(
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ProductDetails(productsData[i].id)));
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      products[i].imageUrl,
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
                                    text: products[i].title,
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
                                products[i].price.toString(),
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
        ),
      ),
      addAutomaticKeepAlives: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
