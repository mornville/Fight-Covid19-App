import 'package:flutter/material.dart';
import 'login.dart' as loginScreen;
import 'registration.dart' as regisScreen;
import 'dashboard.dart' as dashboard;
import 'reportHealth.dart' as repHealth;
import 'myProfile.dart' as mp;
import 'news.dart' as news;
import 'statewise.dart' as st;
import 'splashScreen.dart' as splash;
import 'getting_started.dart' as gt;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fight-Covid19 Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
        brightness: Brightness.light,
        backgroundColor: Color(0xFFE5E5E5),
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.black,
        accentIconTheme: IconThemeData(color: Colors.white),
        dividerColor: Colors.white54,
      ),

      home: splash.SplashScreen(),
      routes: {
        '/login': (context) => loginScreen.LoginScreen(),
        '/registration': (context) => regisScreen.RegistrationScreen(),
        '/dashboard' : (context) => dashboard.Dashboard(),
        '/reportHealth' : (context) => repHealth.ReportHealth(),
        '/myProfile': (context)=> mp.MyProfile(),
        '/news': (context) => news.News(),
        '/statewise' : (context) => st.StateWise(),
        '/gettingStarted': (context) => gt.GettingStartedScreen()
      },
    );
  }
}

