import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';
class ReportHealth extends StatefulWidget {
  @override
  _ReportHealthState createState() => _ReportHealthState();
}

class _ReportHealthState extends State<ReportHealth> {
  void _showDialog(text) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:  Text("Couldnt Submit Your Report."),
          content:  Text(text??'Server Error'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child:  Text("Try Again"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _username, _lat, _long;
  final TextEditingController _controllerLat =  TextEditingController();
  final TextEditingController _controllerLong =  TextEditingController();
  bool fever, cough, selfQuarantine, difficultBreathing;
  Position _currentPosition;

    _getCurrentLocation() {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        if (this.mounted){
          setState((){
            _currentPosition = position;
            _lat = _currentPosition.latitude.toString();
            _controllerLat.text = _lat;
            _long = _currentPosition.longitude.toString();
            _controllerLong.text = _long;
            print(_currentPosition);
          });
        }
      }).catchError((e) {
        print(e);
      });
    }

  void initState() {
    cough = false;
    selfQuarantine = false;
    difficultBreathing = false;
    fever = false;
    _lat = 'null';
    _long = 'null';
    super.initState();
  }
  Future<void> _submitReport() async {

    // Getting smitty api instance
    print("inside preform logic method");

    api.Covid19API a = api.Covid19API();
    print('reportHealth');
    var d = await a.healthStat();
    print(d);
    Map data = await a.healthEntry(username: _username,fever: fever, cough: cough, self_quarantine: selfQuarantine, latitude: _lat, longitude: _long, difficult_breathing: difficultBreathing);
    final error = data['info'];

    if (data['status'] == 'success') {
      _showDialog('Your Report has been submitted');
      Navigator.pushNamed(context, '/dashboard');

      }
     else {
      print("Unable to Create.");
      print(error);

      _showDialog(error.toString().replaceAll('[', ' ').replaceAll(']', ' ')??'Internal Error');

    }
  }

  //submitForm
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _submitReport();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(left:30.0, top:10.0, right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Health Status Form', style: TextStyle(color: Colors.green,fontFamily: 'Poppins', fontSize: 20.0, fontWeight: FontWeight.w600),),
                    Text('Please fill the form below. This information would help a lot of people', style: TextStyle(color: Colors.black54,fontFamily: 'Raleway', fontSize: 14.0, fontWeight: FontWeight.w600),),

                    SizedBox(
                      height: 40.0,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [

                          Material(
                            elevation: 1.0,
                            shadowColor: Colors.white,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.account_circle),
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                labelText: "Username",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500),
                                fillColor: Colors.white,

                                //fillColor: Colors.green
                              ),
                              validator: (val) => val.length <= 1
                                  ? '\This field Can\'t be Empty\n'
                                  : null,
                              onSaved: (val) => _username = val,
                            ),
                          ),

                          SizedBox(height: 30.0,),
                          Text('Please allow us to know your location. This might help us forecast future outbreaks. To know ypur location click below.', style: TextStyle(color: Colors.black54,fontFamily: 'Raleway', fontSize: 14.0, fontWeight: FontWeight.w600),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: FlatButton(
                                  onPressed: (){
                                    _getCurrentLocation();

                                  },
                                  child: Text('Know my Location', style: TextStyle(color: Colors.indigo, fontFamily: 'Raleway', fontWeight: FontWeight.w500),),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Material(
                            elevation: 1.0,
                            shadowColor: Colors.white,
                            child: TextFormField(
                              controller: _controllerLat,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.location_on),
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                labelText: "Latitude",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500),
                                fillColor: Colors.white,

                                //fillColor: Colors.green
                              ),
                              validator: (val) => val.length <= 1
                                  ? '\This field Can\'t be Empty\n'
                                  : null,
                              onSaved: (val) => _lat = val,
                            ),
                          ),

                          SizedBox(height: 10.0,),
                          Material(
                            elevation: 1.0,
                            shadowColor: Colors.white,
                            child: TextFormField(
                              controller: _controllerLong,
                              keyboardType: TextInputType.numberWithOptions(),

                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.location_on),
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                labelText: "Longitude",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500),
                                fillColor: Colors.white,

                                //fillColor: Colors.green
                              ),
                              validator: (val) => val.length <= 1
                                  ? '\This field Can\'t be Empty\n'
                                  : null,
                              onSaved: (val) => _long = val,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),

                          SizedBox(height: 10.0,),


                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Do you have fever?', style: TextStyle(color: Colors.black54,fontFamily: 'Raleway', fontSize: 15.0, fontWeight: FontWeight.w600),),

                                    Checkbox(
                                      value: fever,
                                      onChanged: (bool value) {
                                        setState(() {
                                          fever = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),


                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Do you have cough?', style: TextStyle(color: Colors.black54,fontFamily: 'Raleway', fontSize: 15.0, fontWeight: FontWeight.w600),),

                                    Checkbox(
                                      value: cough,
                                      onChanged: (bool value) {
                                        setState(() {
                                          cough = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),


                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Any difficulty breathing?', style: TextStyle(color: Colors.black54,fontFamily: 'Raleway', fontSize: 15.0, fontWeight: FontWeight.w600),),

                                    Checkbox(
                                      value: difficultBreathing,
                                      onChanged: (bool value) {
                                        setState(() {
                                          difficultBreathing = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),


                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Are you self-quarantined?', style: TextStyle(color: Colors.black54,fontFamily: 'Raleway', fontSize: 15.0, fontWeight: FontWeight.w600),),

                                    Checkbox(
                                      value: selfQuarantine,
                                      onChanged: (bool value) {
                                        setState(() {
                                          selfQuarantine = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),

SizedBox(
  height: 20.0,
),
                          Material(
                            elevation: 1.0,
                            borderRadius: BorderRadius.circular(40.0),
                            color: Color.fromRGBO(64,146,240 ,1),
                            child: MaterialButton(
                              minWidth: 200.0,
                              padding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                _submit();
                              },
                              child: Text("Submit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w500, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
