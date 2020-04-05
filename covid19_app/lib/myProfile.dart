import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

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

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {



  void initState() {

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments;

    Map currentuser = arg['currentuser'];
    print('user');
    print(currentuser);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    Text('Hey' +  '  '+ currentuser['username'] + ' !', style: TextStyle(color: Colors.green,fontFamily: 'Poppins', fontSize: 20.0, fontWeight: FontWeight.w600),),
                    Text('Your Information', style: TextStyle(color: Colors.black54,fontFamily: 'Oswald', fontSize: 25.0, fontWeight: FontWeight.w600),),
                    SizedBox(
                      height: 30.0,
                    ),
                    Form(
                      child: Column(
                        children: [
                          Material(
                            elevation: 1.0,
                            shadowColor: Colors.white,
                            child: TextFormField(
                              initialValue: currentuser['username'],
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

                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Material(
                            elevation: 1.0,
                            shadowColor: Colors.white,
                            child: TextFormField(
                              initialValue: currentuser['email'],
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.alternate_email),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  labelText: "Email Address",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w500),
                                  fillColor: Colors.white,

                                //fillColor: Colors.green
                              ),

                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),

                          SizedBox(
                            height: 30.0,
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
