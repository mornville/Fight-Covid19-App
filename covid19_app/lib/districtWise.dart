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
              flex: 2,
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

          ],
        ),
        SizedBox(
          height: 10.0,
        ),

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;

    List districtWise = data['stateData'];
    String state = data['state'];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            state.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'Montserrat'),
          ),
          centerTitle: true,


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
                            flex: 2,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                'Confirmed Cases',
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
