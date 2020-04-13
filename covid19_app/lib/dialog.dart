import 'package:flutter/material.dart';

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
                  backgroundColor: Colors.black,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                       Image.asset('assets/wait.gif',
                       height: 50.0,
                       width: 50.0,),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    )
                  ]));
        });
  }
}