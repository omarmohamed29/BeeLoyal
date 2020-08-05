import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({@required this.imageUrl,@required this.title,@required this.description});
}
final slideList = [
 Slide(
   imageUrl: 'assets/images/beel.png',
   title: 'welcome to Bee loyal app ',
   description: 'with our app forget the  traditional loyalty cards ,no more breakable or lost cards',
 ),
  Slide(
    imageUrl: 'assets/images/welcome2.jpg',
    title: 'new easy payment methods',
    description: 'With bee loyal you can buy whatever you want with just one click.Yes,just that easy',
  ),
  Slide(
    imageUrl: 'assets/images/welcome3.jpg',
    title: 'collect points , get rewards',
    description: 'collect points from your payment and get  rewards,discounts even muchmore',
  ),
];