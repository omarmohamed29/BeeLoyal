import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/Users.dart';
import '../Screens/SearchScreen.dart';

class TopSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Consumer<Users>(
          builder: (_, user, ch) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome ",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                  fontFamily: "Montserrat-Light",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                user.users[0].name,
                style: TextStyle(
                  color: Color(0xFFFFCB5F),
                  fontFamily: "Montserrat-Light",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Are you ready to get fashioned ? ",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline2.color,
            fontFamily: "Montserrat-Bold",
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async{
            await showSearch(
                context: context, delegate: ProductSearch());
          },
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    width: 0.5,
                    color: Theme.of(context).textTheme.headline2.color),
              )),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 25,
                      color: Color(0xFFFFCB5F),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'What are you looking for today',
                      style: TextStyle(
                          fontFamily: "Montserrat-Light",
                          color: Colors.grey,
                          fontSize: 15.0),
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
