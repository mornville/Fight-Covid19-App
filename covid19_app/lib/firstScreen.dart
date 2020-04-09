import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dialog.dart' as dg;
import 'package:covid19_app/api_wrapper.dart' as api;

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
  void initState() {
    super.initState();
    _getCorona(context);
  }


  Future<void> _getCorona(BuildContext context) async {
    try {
      print("inside preform logic method");
      api.Covid19API a = api.Covid19API();
      Map data = await a.login('mornville', 'apple007');


      if (data['status'] == 'success') {
        Map hoiStat = await a.healthStat();
        Map temp = await a.coronaCases();
        print("Fetching successful");
        //Checking if the user is Admin or employee

        Navigator.pushReplacementNamed(context, '/dashboard', arguments: {
          'total':temp['info'], 'hoiStat':hoiStat['info'],
        });
      } else {
        dg.showDialogBox(context, 'Make sure you are connected to the internet.');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(26, 135, 197, 1),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Image.asset('assets/loading.gif'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
