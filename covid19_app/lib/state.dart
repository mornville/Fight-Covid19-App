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

class StateData extends StatefulWidget {
  @override
  _StateDataState createState() => _StateDataState();
}

class _StateDataState extends State<StateData> {
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

        Navigator.pushReplacementNamed(context, '/dashboard',
            arguments: {'cases': data['info']});
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
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
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


    Map cases = data["cases"]["statewise"];


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
                      _settingModalBottomSheet(context);
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
            body: Container(
              child: Padding(
                padding: EdgeInsets.only(top:10.0, left:5.0, right:5.0),
                child: ListView.builder(
                  itemCount: cases.length,
                  itemBuilder: (context, int i) => Column(
                    children: [
                      Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ListTile(
                              title: Text(
                                i.toString(),
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
                    ],
                  ),
                ),
              ),
            )));
  }
}
