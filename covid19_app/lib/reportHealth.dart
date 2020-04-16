import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';
import'dialog.dart' as dg;
void showDialogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Legend", style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
            color: Colors.black,
            fontFamily: 'Raleway'),),
        content: Container(
          height: 100.0,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 10.0,
                    width: 10.0,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Total Cases', style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                      color: Colors.black,
                      fontFamily: 'Montserrat'),),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 10.0,
                    width: 10.0,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Active Cases', style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                      color: Colors.black,
                      fontFamily: 'Montserrat'),),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 10.0,
                    width: 10.0,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Recovered Patients', style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                      color: Colors.black,
                      fontFamily: 'Montserrat'),),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 10.0,
                    width: 10.0,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Deceased', style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                      color: Colors.black,
                      fontFamily: 'Montserrat'),),
                ],
              ),
            ],
          ),
        ),
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
          title: Text("Couldnt Submit Your Report."),
          content: Text(text ?? 'Server Error'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("Try Again"),
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
  String _lat, _long, _age;
  String dropdownValue = 'Female';
  final List<String> genderList = ['Male', 'Female'].toList();
  String _gender;

  final TextEditingController _controllerLat = TextEditingController();
  final TextEditingController _controllerLong = TextEditingController();
  bool fever, cough, selfQuarantine, difficultBreathing;
  Position _currentPosition;

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (this.mounted) {
        setState(() {
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
    _gender = genderList.isEmpty ? "Gender" : genderList.first;

    super.initState();
  }

  //submitForm
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _submitReport(context);
    }
  }

  Future<void> _submitReport(BuildContext context) async {
    try {
      dg.Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside submit report logic");
      final sharedPrefs = await SharedPreferences.getInstance();
      var token = sharedPrefs.getString("token");
      api.Covid19API a = api.Covid19API();
      a.token = token;
      print('reportHealth');
      if(_gender == "Female"){
        _gender = 'F';
      }else if(_gender == "Male"){
        _gender = 'M';
      }else{
        _gender = 'M';
      }
      if(int.parse(_age)<=0 ||int.parse(_age) >= 150){
        _showDialog('Enter a valid age');
        return;
      }
      Map login = await a.login('mornville', 'apple007');
      Map aa = await a.getUniqueId();
      Map data = await a.healthEntry(
          age: int.parse(_age),
          latitude: _lat,
          longitude: _long,
          self_quarantine: selfQuarantine,
          fever: fever,
          difficult_breathing: difficultBreathing,
          unique_id: aa['info']['id'],
          cough: cough,
          gender: _gender);
      final error = data['info'];

      if (data['status'] == 'success') {
        print("Submission successful");
        //Checking if the user is Admin or employee
        Navigator.pop(context); //close the dialogue
Navigator.pop(context);
      } else {
        print("Unable to Submit Data.");
        Navigator.pop(context); //close the dialogue
        _showDialog(
            error.toString().replaceAll('[', ' ').replaceAll(']', ' ') ??
                'Internal Error');
      }
    } catch (error) {
      print(error);
    }
    // Getting smitty api instance and shared_preference storage instance
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            padding: EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Health Status Form',
                  style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Poppins',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Please fill the form below. This information would help a lot of people',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Raleway',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
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
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            labelText: "What is your age?",
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
                          onSaved: (val) => _age = val,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'What is your gender?',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Raleway',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black54,
                                    style: BorderStyle.solid,
                                    width: 0.0),
                              ),
                              child: DropdownButton<String>(
                                value: _gender,
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w500),
                                underline: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                  ),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _gender = newValue;
                                  });
                                },
                                items: genderList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(width: 20),
                                        Text(
                                          value,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 17.0,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Do you have fever?',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Raleway',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
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
                                Text(
                                  'Do you have cough?',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Raleway',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
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
                                Text(
                                  'Any difficulty breathing?',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Raleway',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
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
                                Text(
                                  'Are you self-quarantined?',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Raleway',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
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
                        height: 10.0,
                      ),
                      Text(
                        'Please allow us to know your location. This might help us forecast future outbreaks. To know ypur location click below.',
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Raleway',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: FlatButton(
                              onPressed: () {
                                _getCurrentLocation();
                              },
                              child: Text(
                                'Know my Location',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500),
                              ),
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
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                      SizedBox(
                        height: 10.0,
                      ),
                      Material(
                        elevation: 1.0,
                        shadowColor: Colors.white,
                        child: TextFormField(
                          controller: _controllerLong,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.location_on),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                      SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        elevation: 1.0,
                        borderRadius: BorderRadius.circular(40.0),
                        color: Color.fromRGBO(64, 146, 240, 1),
                        child: MaterialButton(
                          minWidth: 200.0,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            _submit();
                          },
                          child: Text("Submit",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18)),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
