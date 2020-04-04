import 'package:flutter/material.dart';
class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/landing.jpg'), fit: BoxFit.cover ),
              ),
              child: null /* add child content here */,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              child: Image.asset(
                                'assets/logo.png',
                                height: 100.0,
                              ),
                              padding: EdgeInsets.only(
                                  top: 8.0, left: 0.0, right: 8.0, bottom: 10.0),
                            ),
                          ),
                          Text(
                            'Health Of India',
                            style: TextStyle(
                                fontSize: 35.0,
                                color: Colors.white,
                                fontFamily: 'Oswald'),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            'Let\'s fight Covid19 together. ',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(40.0),
                            color: Color.fromRGBO(64, 146, 240, .7),
                            child: MaterialButton(
                              minWidth: 300.0,
                              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                Navigator.pushNamed(context, '/registration');
                              },
                              child: Text("Create a New Account",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(40.0),
                            color: Color.fromRGBO(85, 85, 85, .7),
                            child: MaterialButton(
                              minWidth: 300.0,
                              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text("Login to My Account",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
