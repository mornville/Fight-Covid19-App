import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/landingScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Stack(
children: <Widget>[
  Container(
    color: Color.fromRGBO(14, 30,47, 1),
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child:  Center(
      child: Image.asset('assets/splash.gif'),
    ),
  ),
],      ),
    );
  }
}