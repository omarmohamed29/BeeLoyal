import 'slide.dart';
import 'package:flutter/material.dart';
class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index );
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image:
                  AssetImage(slideList[index].imageUrl),
                  fit: BoxFit.cover)),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          slideList[index].title,
          style: TextStyle(fontSize: 22, color: Color(0xFFFFCB5F) , fontFamily: "Montserrat-Bold"),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          slideList[index].description,
          style: TextStyle(color: Color(0xFF3F3C36) ,fontFamily: "Montserrat-Light" ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
