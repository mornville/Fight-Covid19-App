import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:covid19_app/api_wrapper.dart' as api;

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future<void> showDialogBox(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Something went wrong"),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _getData(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside preform logic method");
      api.Covid19API a = api.Covid19API();

      final sharedPrefs = await SharedPreferences.getInstance();
      var token = sharedPrefs.getString("token");
      a.token = token;
      Map data = await a.coronaCases();

      if (data['status'] == 'success') {
        print("Accessed Data");
        sharedPrefs.setString("token", a.token);
        Map data = await a.coronaCases();
        print(data);
        print("token stored");
        //Checking if the user is Admin or employee
        Navigator.pop(context); //close the dialogue

        Navigator.pushReplacementNamed(context, '/stateData', arguments: {
          'cases':data['info']
        });
      } else {
        print("Unable to login.");
        Navigator.pop(context); //close the dialogue
        showDialogBox(context, data['info']);
      }
    } catch (error) {
      print(error);
    }
    // Getting smitty api instance and shared_preference storage instance
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Log Out?",
            style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700,
                fontSize: 15.0),
          ),
          content: Text("Are You Sure You want to Log Out?.",
              style: TextStyle(fontFamily: 'Raleway', color: Colors.black54)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                'Log Out',
                style: TextStyle(fontFamily: 'Raleway', color: Colors.red),
              ),
              onPressed: () {
                //deleteUser(user_id);
                logout(context);
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Raleway'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //logout
  Future<void> logout(BuildContext context) async {
    // remove token from shared prefs
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove("token");
    // Navigate back to login screen
    Navigator.pushReplacementNamed(context, "/login");
  }

  openBrowserTab(url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: Colors.black);
  }

  void initState() {
    super.initState();
  }

  //bottomDrawer
  void _settingModalBottomSheet(context, Map temp) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/user.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'My Profile',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/myProfile', arguments: {
                        'currentuser':temp
                      });                    }),
                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/address.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'Check Patients on Map',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      openBrowserTab("https://covid19.thepodnet.com/maps/");
                    }),

                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/news.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'News Board',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      openBrowserTab("https://covid19.thepodnet.com/news/");
                    }),
                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/edit.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'Record My Health',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/reportHealth');
                    }),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
    Map cases = data["cases"];
    Map currentuser = data['currentuser'];

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _showDialog();
                    },
                  ),
                ),
              ],
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
              label: Text(
                'Report Health',
                style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 0.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/reportHealth');
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () =>
                        openBrowserTab("https://covid19.thepodnet.com/maps/"),
                    child: Padding(
                        child: Image.asset(
                          'assets/address.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                  ),
                  FlatButton(
                    onPressed: () {
                      _settingModalBottomSheet(context, currentuser);
                    },
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
            body: SingleChildScrollView(
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
                              cases['confirmed'] ?? 'N/A',
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
                                    top: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    bottom: 0.0))),
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
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0)),
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
                                          cases['deaths'] ?? 'N/A',
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
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0)),
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
                                          cases['deltaconfirmed'] ?? 'N/A',
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
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0)),
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
                                          cases['recovered'] ?? 'N/A',
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
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0)),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Active Cases',
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
                                          cases['active'] ?? 'N/A',
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
//                    Card(
//                      elevation: 10.0,
//                      child: Padding(
//                        padding: EdgeInsets.all(10.0),
//                        child: ListTile(
//                            title: Text(
//                              'View State wise data',
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 20.0,
//                                  fontWeight: FontWeight.w700),
//                            ),
//                            onTap: (){
//                              _getData(context);
//                            },
//                            trailing: Padding(
//                                child: Image.asset(
//                                  'assets/link.png',
//                                  height: 50.0,
//                                ),
//                                padding: EdgeInsets.only(
//                                    top: 0.0,
//                                    left: 0.0,
//                                    right: 0.0,
//                                    bottom: 0.0))),
//                      ),
//                    ),
//                    SizedBox(
//                      height: 5.0,
//                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            child: Text(
                              'Health of India Statistics',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w900),
                            ),
                            padding: EdgeInsets.only(
                                left: 10.0, top: 30.0, bottom: 20.0),
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
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0)),
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
                                          cases['totalPeople'].toString() ??
                                              'N/A',
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
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0)),
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
                                          cases['sickPeople'].toString(),
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
            )));
  }
}
