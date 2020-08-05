import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/Cart.dart';
import '../Providers/Products.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String image;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      this.image);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red.withOpacity(0.6),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure !'),
            content: Text('Do you want to remove this item from cart ?!'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
        final theProd = Provider.of<Products>(context, listen: false).findById(productId);
        await Provider.of<Products>(context, listen: false).updateProd(
            theProd.id,
            theProd.title,
            theProd.description,
            theProd.price,
            theProd.imageUrl,
            theProd.color,
            theProd.brand,
            theProd.category,
            theProd.subCategory,
            theProd.hits - 1,
            theProd.inStock +1);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(image),
              backgroundColor: Colors.transparent,
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat-Bold",
                  fontSize: 15,
                  color: Color(0xFF3F3C36)),
            ),
            subtitle: Text('Total : \$${(price * quantity)}' ,
              style: TextStyle(
                  fontFamily: "Montserrat-Light",
                  fontSize: 13,
                  color: Color(0xFF3F3C36)),),
            trailing: Text(
              '$quantity x',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat-Bold",
                fontSize: 10,
                color: Color(0xFF3F3C36)),
            ),
          ),
        ),
      ),
    );
  }
}
