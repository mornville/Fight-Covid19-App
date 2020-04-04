import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}



class _DashboardState extends State<Dashboard> {
  _launchURL() async {
    const url = 'https://covid19.thepodnet.com/maps/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(url: "https://covid19.thepodnet.com/maps/", androidToolbarColor: Colors.black);
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
        leading: Container(),
        centerTitle: true,
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
        label: Text('Report Health', style:TextStyle(fontFamily: 'OpenSans', letterSpacing: 0.0),),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () => openBrowserTab(),

              child: Padding(
                  child: Image.asset(
                    'assets/address.png',
                    height: 30.0,
                  ),
                  padding: EdgeInsets.only(
                      top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
            ),
            FlatButton(
              onPressed: () {},
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
      body:SingleChildScrollView(
        child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.0,
                  ),
                  Card(
                    elevation: 10.0,

                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          'Total Number of Cases',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '3082',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 35.0,
                              fontWeight: FontWeight.w700),
                        ),
                        trailing: Padding(
                            child: Image.asset(
                              'assets/population.png',
                              height: 50.0,
                            ),
                            padding: EdgeInsets.only(
                                top: 0.0, left: 0.0, right: 0.0, bottom: 0.0))
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          elevation: 10.0,
                          color: Colors.white,

                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(

                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        child: Image.asset(
                                          'assets/tombstone.png',
                                          height: 70.0,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 0.0, right: 0.0, bottom: 0.0)),

                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Total Deaths',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontSize: 16.0,
                                          ),
                                    ),
                                  ],
                                ),
                                subtitle: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '3434',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 10.0,
                          color: Colors.white,

                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(

                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        child: Image.asset(
                                          'assets/down.png',
                                          height: 70.0,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 0.0, right: 0.0, bottom: 0.0)),

                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Today\'s Cases',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '27',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          elevation: 10.0,
                          color: Colors.white,

                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(

                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        child: Image.asset(
                                          'assets/patient.png',
                                          height: 70.0,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 0.0, right: 0.0, bottom: 0.0)),

                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Recovered',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '229',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 10.0,
                          color: Colors.white,

                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(

                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        child: Image.asset(
                                          'assets/infected.png',
                                          height: 70.0,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 0.0, right: 0.0, bottom: 0.0)),

                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Crirical Cases',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          child: Text('Health of India Statistics', style: TextStyle(color: Colors.black,fontSize: 22.0, fontFamily: 'OpenSans', fontWeight: FontWeight.w900),)
                          ,
                          padding: EdgeInsets.only(left:10.0, top:30.0, bottom:20.0),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          elevation: 10.0,
                          color: Colors.white,

                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(

                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        child: Image.asset(
                                          'assets/teamwork.png',
                                          height: 70.0,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 0.0, right: 0.0, bottom: 0.0)),

                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Total Number of People',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '6',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 10.0,
                          color: Colors.white,

                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(

                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        child: Image.asset(
                                          'assets/virus.png',
                                          height: 60.0,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 0.0, right: 0.0, bottom: 0.0)),

                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Symptomatic People',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],

              ),

            )),
      )
    );
  }
}
