import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:covid19_app/api_wrapper.dart' as api;
import 'dialog.dart' as dg;


class DistrictWise extends StatefulWidget {
  @override
  _DistrictWiseState createState() => _DistrictWiseState();
}

class _DistrictWiseState extends State<DistrictWise> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List stateData = List();


  //Card Widget
  Widget ColumnInfo(String district, int confirmed, int dc, int i) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child:
              Text(
                (i+1).toString() + '. ' +district.toString().toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ) ,
            ),
            Expanded(
              flex: 1,
              child:
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Text(
                 confirmed.toString() ?? 'N/A',
                 style: TextStyle(
                     color: Color.fromRGBO(196, 75, 75, 1),
                     fontSize: 17.0,
                     fontWeight: FontWeight.w700),
               ),],
             ),
            ),
            Expanded(
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (' [' + '+' + dc.toString() + ']'),
                    style: TextStyle(
                        color: Color.fromRGBO(196, 75, 75, .8),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),

      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;

    List districtWise = data['stateData'];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "StateWise Data",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'Montserrat'),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                showDialogBox(context);
              },
            ),
          ],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
        ),
        body:Container(
            child: Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top:5.0, bottom: 5.0),
              child: Card(
                elevation: 10.0,
                child: Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 2.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child:
                            Text(
                              'District ' + '(' +districtWise.length.toString() +')',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ) ,
                          ),
                          Expanded(
                            flex: 1,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0,
                                ),
                              ) ,

                              ],
                            ),
                          ),
                          Expanded(
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text(
                                'Today\'s',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0,
                                ),
                              ) ,

                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: districtWise.length,
                              itemBuilder: (BuildContext context, int i) {
                                return ColumnInfo(
                                  districtWise[i][0],
                                  districtWise[i][2],
                                  districtWise[i][1],
                                  i,

                                );
                              }))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
