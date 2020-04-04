import 'package:flutter/material.dart';

class ReportHealth extends StatefulWidget {
  @override
  _ReportHealthState createState() => _ReportHealthState();
}

class _ReportHealthState extends State<ReportHealth> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _username, _lat, _long;
  bool fever, cough, selfQuarantine, difficultBreathing;

  void initState() {
    cough = false;
    selfQuarantine = false;
    difficultBreathing = false;
    fever = false;
    _lat = 'null';
    _long = 'null';
    super.initState();
  }

  //submitForm
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Submitted');
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
                          Text('Please allow us to know your location. This might help us forecast future outbreaks.', style: TextStyle(color: Colors.black54,fontFamily: 'Raleway', fontSize: 14.0, fontWeight: FontWeight.w600),),

                          SizedBox(height: 10.0,),

                          SizedBox(
                            height: 5.0,
                          ),
                          Material(
                            elevation: 1.0,
                            shadowColor: Colors.white,
                            child: TextFormField(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                child: FlatButton(
                                  onPressed: (){},
                                  child: Text('Know my Location', style: TextStyle(color: Colors.indigo, fontFamily: 'Raleway'),),
                                ),
                              ),
                            ],
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
                            color: Color.fromRGBO(64,146,240 ,.3),
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
