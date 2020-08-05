import 'Signup.dart';
import '../widgets/slide.dart';
import '../widgets/slideitem.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'Login.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  static const routeName = '/welcome';
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
     if(_pageController.hasClients){
       _pageController.animateToPage(_currentPage,
           duration: Duration(milliseconds: 300), curve: Curves.easeIn);
     }
    });
  }

  _onPagecChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPagecChanged,
                  itemCount: slideList.length,
                  itemBuilder: (ctx, i) => SlideItem(i),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Getting Started',
                      style: TextStyle(
                          fontSize: 18, fontFamily: "Montserrat-Light"),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(15),
                    color: Color(0xFFFFCB5F),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUp(),
                              fullscreenDialog: true));
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>BottomBar(),
//                              fullscreenDialog: true));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Have an account ?',
                          style: (TextStyle(
                              fontSize: 18, fontFamily: "Montserrat-Light"))),
                      FlatButton(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Montserrat-Bold",
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFCB5F)),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login(),
                                  fullscreenDialog: true));
                        },
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
