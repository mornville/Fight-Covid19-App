import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/services.dart';
import 'dialog.dart' as dg;
import 'package:covid19_app/api_wrapper.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        title:  Text('Are you sure?'),
        content:  Text('Do you want to exit an App'),
        actions: <Widget>[
           GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
           GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }


  Future<void> _getCorona(BuildContext context) async {
    try {
      dg.Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside preform logic method");
      api.Covid19API a = api.Covid19API();
      Map data = await a.login('mornville', 'apple007');


      if (data['status'] == 'success') {
        Map hoiStat = await a.healthStat();
        print(hoiStat);
        Map temp = await a.coronaCases();
        print("Fetching successful");
        //Checking if the user is Admin or employee
        Navigator.pop(context); //close the dialogue

        Navigator.pushReplacementNamed(context, '/dashboard', arguments: {
          'total':temp['info'], 'hoiStat':hoiStat['info'],
        });
      } else {
        Navigator.pop(context); //close the dialogue
        dg.showDialogBox(context, 'Make sure you are connected to the internet.');
      }
    } catch (error) {
      print(error);
    }
    // Getting smitty api instance and shared_preference storage instance
  }


  openBrowserTab(url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: Colors.black);
  }
  //KeyLoader for Dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(40.0),
                color: Color.fromRGBO(85, 85, 85, .7),
                child: MaterialButton(
                  minWidth: 300.0,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    _getCorona(context);
                  },
                  child: Text("Let's Go",
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
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image:  AssetImage(
                  'assets/back.jpg'),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
