import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  //for password
  bool passValue = true;
  bool _togglePassword() {
    return passValue = !passValue;
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
                    Text('Welcome back!', style: TextStyle(color: Colors.green,fontFamily: 'Poppins', fontSize: 20.0, fontWeight: FontWeight.w600),),
                    Text('Login To Your Account', style: TextStyle(color: Colors.black54,fontFamily: 'Oswald', fontSize: 25.0, fontWeight: FontWeight.w600),),
                    SizedBox(
                      height: 60.0,
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
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500),
                                fillColor: Colors.white,

                                //fillColor: Colors.green
                              ),
                              validator: (val) => val.length <= 1
                                  ? '\t Username too short.\n'
                                  : null,
                              onSaved: (val) => _email = val,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Material(
                            elevation: 1.0,
                            shadowColor: Colors.white,
                            child: TextFormField(
                              obscureText: passValue,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.lock_outline),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500),
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        setState(() {
                                          _togglePassword();
                                        });
                                      })
                                //fillColor: Colors.green
                              ),
                              validator: (val) => val.length < 1
                                  ? '\n Not a valid password. \n'
                                  : null,
                              onSaved: (val) => _password = val,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                onPressed: (){},
                                child: Text('Forgot Password?', style: TextStyle(color:Colors.blue, fontSize: 15.0, fontFamily: 'Poppins'),),
                              ),                            ],
                          ),
                          SizedBox(
                            height: 30.0,
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
                                //logic
                              },
                              child: Text("Login",
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
