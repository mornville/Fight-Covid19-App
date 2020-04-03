import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://image.freepik.com/free-vector/worldwide-connection-blue-background-illustration-vector_53876-76810.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: null /* add child content here */,
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 200.0,
              ),
              Expanded(
                flex: 1,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text('Fight-Covid19', style: TextStyle(fontSize: 35.0, color: Colors.white, fontFamily: 'Oswald'),),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text('Let\'s fight Covid19 together. ', style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Poppins'),),
                      ],
                    )

                  )
                ,
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(40.0),
                          color: Color.fromRGBO(64,146,240 ,.7),
                          child: MaterialButton(
                            minWidth: 300.0,
                            padding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              //logic
                            },
                            child: Text("I'm a New User",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w500, fontSize: 18)),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(40.0),
                          color: Color.fromRGBO(85,85,85 ,.7),
                          child: MaterialButton(
                            minWidth: 300.0,
                            padding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              //logic
                            },
                            child: Text("I'm a Registered User",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w500, fontSize: 18)),
                          ),
                        ),
                        SizedBox(
                          height: 100.0,
                        ),
                      ],
                    )

                )
                ,
              ),
            ],
          ),
        ],
      ),

    );
  }
}
