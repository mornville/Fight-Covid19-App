import 'package:flutter/material.dart';
import 'landingScreen.dart' as landingScreen;
import 'login.dart' as loginScreen;
import 'registration.dart' as regisScreen;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fight-Covid19 Application',
      theme: ThemeData(
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
        brightness: Brightness.light,
        backgroundColor: Color(0xFFE5E5E5),
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.black,
        accentIconTheme: IconThemeData(color: Colors.white),
        dividerColor: Colors.white54,
      ),

      home: landingScreen.LandingScreen(),
      routes: {
        '/login': (context) => loginScreen.LoginScreen(),
        '/registration': (context) => regisScreen.RegistrationScreen(),

      },
    );
  }
}

