import 'package:flutter/material.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

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
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String _email;
  String _password;
  //for password
  bool passValue = true;
  bool _togglePassword() {
    return passValue = !passValue;
  }


  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _performLogin(context);
    }
  }


  //check if already logged in
  Future<void> checkIfAlreadyLoggedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var token = sharedPrefs.getString("token");
    print("Checking if the user is already logged in");
    if (token != null && token.isNotEmpty) {
      api.Covid19API a = api.Covid19API();

      a.token = token;
      var d = await a.getCurrentUser();
      Navigator.pushReplacementNamed(context, '/dashboard');

    }
    sharedPrefs.remove("token");
  }

  Future<void> _performLogin(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside preform logic method");
      api.Covid19API a = api.Covid19API();

      final sharedPrefs = await SharedPreferences.getInstance();
      print("performing a login");
      Map data = await a.login(_email, _password);
      var d = await a.getCurrentUser();
      print(d);
      if (data['status'] == 'success') {
        print("Login successful");
        sharedPrefs.setString("token", a.token);
        print("token stored");
        //Checking if the user is Admin or employee
        Navigator.pop(context); //close the dialogue

        Navigator.pushReplacementNamed(context, '/dashboard');
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

  @override
  void initState() {
    checkIfAlreadyLoggedIn();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:(){
          Navigator.pushReplacementNamed(context, '/landingScreen')
        }
          ,
        child:Scaffold(
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
            Navigator.pushReplacementNamed(context, '/landingScreen');
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
                                  fontFamily: 'Raleway',
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
                                    fontFamily: 'Raleway',
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
_submit()        ;                    },
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
    ));
  }
}
