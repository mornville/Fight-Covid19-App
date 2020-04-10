import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'dialog.dart' as dg;
import 'package:percent_indicator/percent_indicator.dart';

//Card Widget
Widget CardInfo(
    String title, String number, String image, String delta, Color color) {
  return Card(
    elevation: 10.0,
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  child: Image.asset(
                    image,
                    height: 70.0,
                  ),
                  padding: EdgeInsets.only(
                      top: 0.0, left: 0.0, right: 0.0, bottom: 0.0)),
              SizedBox(
                height: 10.0,
              ),
              Text(
                title,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      number ?? 'N/A',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      delta == ' ' || delta == null
                          ? ' '
                          : (' [' + '+' + delta.toString() + ']'),
                      style: TextStyle(
                          color: color,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          )),
    ),
  );
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map news = Map();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  //Important Functions
  Future<void> _getNews(BuildContext context, int flag) async {
    try {
      //use this only when bottomDrawer is open
      if(flag == 1){
        Navigator.pop(context);

      }
      dg.Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside getNews");
      api.Covid19API a = api.Covid19API();
      Map data = await a.login('mornville', 'apple007');
      if (data['status'] == 'success') {
        Map hoiStat = await a.getNews();
        news = hoiStat['info'];
        Navigator.pop(context);
//Checking if the user is Admin or employee
        Navigator.pushNamed(context, '/news',
            arguments: {'news': news}); //close the dialogue

      } else {
        Navigator.pop(context); //close the dialogue
        dg.showDialogBox(
            context, 'Make sure you are connected to the internet.');
      }
    } catch (error) {
      print(error);
    }
    // Getting smitty api instance and shared_preference storage instance
  }

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

  List statewise = List();

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
                      'News Related to COVID-19',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      _getNews(context, 1);
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
    Map coronaCases = Map();
    Map hoiStat = Map();
    double perc;
    if (data != null) {
      coronaCases = data['total']['total_stats'];
      hoiStat = data['hoiStat'];
      statewise = data['total']['statewise'].values.toList();
      print(statewise);
      perc =  (int.parse(coronaCases['recovered'])/int.parse(coronaCases['confirmed']));
    }


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
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          )),
          actions: <Widget>[

          Padding(
            padding: EdgeInsets.only(right:10.0),
            child:   IconButton(
              icon: Icon(Icons.info, color:Colors.white, size: 30,),
              onPressed: (){
                Navigator.pushNamed(context, '/gettingStarted');
              },
            ),
          ),

          ],
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                      'assets/gps.png',
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
        body: SingleChildScrollView(
          child: Container(
              child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 7.0,
                ),
                Card(
                  elevation: 10.0,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListTile(
                        title: Text(
                          'Get Statewise Data',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: ()
                        {
                          Navigator.pushNamed(context, '/statewise',
                          arguments: {'state': statewise});

  },

                        trailing: Padding(
                            child: Image.asset(
                              'assets/link.png',
                              height: 50.0,
                            ),
                            padding: EdgeInsets.only(
                                top: 0.0, left: 0.0, right: 0.0, bottom: 0.0))),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Card(
                  elevation: 10.0,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListTile(
                        title: Text(
                          'News Related to COVID-19',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: ()
                        {
                          _getNews(context, 0);


                        },

                        trailing: Padding(
                            child: Image.asset(
                              'assets/news.png',
                              height: 50.0,
                            ),
                            padding: EdgeInsets.only(
                                top: 0.0, left: 0.0, right: 0.0, bottom: 0.0))),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CardInfo(
                          'Active Cases',
                          coronaCases['active'].toString(),
                          'assets/infected.png',
                          coronaCases['deltaactive'],
                          Colors.red),
                    ),
                    Expanded(
                      child: CardInfo(
                          'Total Deceased',
                          coronaCases['deaths'].toString(),
                          'assets/tombstone.png',
                          coronaCases['deltadeaths'],
                          Colors.red),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CardInfo(
                          'Recovered ',
                          coronaCases['recovered'].toString(),
                          'assets/patient.png',
                          coronaCases['deltarecovered'],
                          Colors.green),
                    ),

                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth:8.0,
                            animation: true,
                            percent:perc,
                            center:  Text(
                              (perc*100).toString().substring(0,5) + '%',
                              style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            footer:  Text(
                              "Recovery Rate",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),)
                            ,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: <Widget>[
                   Padding(
                     child: Text(
                       '*Last Updated: ' +
                           (coronaCases['lastupdatedtime'] ?? 'Recently'),
                       style: TextStyle(
                         color: Colors.black,
                         fontFamily: 'Poppins',
                         fontSize: 13.0,
                       ),
                     ),
                     padding: EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                   ),
                 ],
               ),
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
                        padding:
                            EdgeInsets.only(left: 10.0, top: 30.0, bottom: 0.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  child: Text(
                    'Last Updated: ' +
                        (coronaCases['lastupdatedtime'] ?? 'Recently'),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 13.0,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10.0, top: 0.0, bottom: 10.0),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CardInfo(
                          'Total People',
                          hoiStat['totalPeople'].toString(),
                          'assets/teamwork.png',
                          ' ',
                          Colors.black),
                    ),
                    Expanded(
                      child: CardInfo(
                          'Sick People',
                          hoiStat['sickPeople'].toString(),
                          'assets/virus.png',
                          ' ',
                          Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CardInfo(
                          'People with Fever',
                          hoiStat['fever'].toString(),
                          'assets/fever.png',
                          ' ',
                          Colors.black),
                    ),
                    Expanded(
                      child: CardInfo(
                          'Shortness Of Breath',
                          hoiStat['shortnessOfBreath'].toString(),
                          'assets/breath.png',
                          ' ',
                          Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          )),
        ));
  }
}
