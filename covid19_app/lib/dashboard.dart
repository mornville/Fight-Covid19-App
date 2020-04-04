import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Health of India",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
              color: Colors.white,
              fontFamily: 'Montserrat'),
        ),

leading:Container(),           centerTitle: true,
        actions: <Widget>[],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
            title: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: Icon(Icons.edit_location),
        label: Text('Report Health'),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            FlatButton(
              onPressed: _launchURL,
              child: Padding(
                  child: Image.asset(
                    'assets/address.png',
                    height: 30.0,
                  ),
                  padding: EdgeInsets.only(
                      top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
            ),
            FlatButton(
              onPressed: (){},
              child: Padding(
                  child: Image.asset(
                    'assets/trail.png',
                    height: 30.0,
                  ),
                  padding: EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 0.0, bottom: 10.0)),
            ),
          ],
        ),
      ),
    );
  }
}
