import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'dialog.dart' as dg;


class StateWise extends StatefulWidget {
  @override
  _StateWiseState createState() => _StateWiseState();
}

class _StateWiseState extends State<StateWise> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Map data = Map();
  Future<void> _getStateData(BuildContext context, String state) async {
    try {
      dg.Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside getNews");
      api.Covid19API a = api.Covid19API();
      List stateData = List();

      data = await a.getStateData();
      if (data['status'] == 'success') {
        if(data['info'][state] == null){
          Navigator.pop(context);
          dg.showDialogBox(context, 'No data for: ' + state.toString());
        }
        else{
          List districts = data['info'][state]['districtData'].keys.toList();
          for(int i=0;i<districts.length;i++){
            int delConfirmed = data['info'][state]['districtData'][districts[i]].values.toList()[2]['confirmed'];
            String dis = districts[i];
            int confirmed = data['info'][state]['districtData'][districts[i]].values.toList()[0];
            print(dis + delConfirmed.toString() + ' =' + confirmed.toString() );
            stateData.add([dis, delConfirmed, confirmed]);
          }
          Navigator.pop(context);
          Navigator.pushNamed(context, '/districtData',
              arguments: {'stateData': stateData, 'state':state});
        }
         //close the dialogue

      } else {
        Navigator.pop(context); //close the dialogue
        dg.showDialogBox(
            context, 'Make sure you are connected to the internet.');
      }
    } catch (error) {
      print(error);
    }
    // Getting smitty api instance and shared_preference storage instance
  }
void initState(){
    super.initState();
}

  //Card Widget
  Widget ColumnInfo(String state, String c, String dc, String a, String da,
      String r, String dr, String d, String dd) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          title:Text(
            state.toUpperCase(),
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
          ) ,
          subtitle: Column(

            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[

                        Text(
                          dc == ' ' || dc == null
                              ? ' '
                              : (' [' + '+' + dc.toString() + ']'),
                          style: TextStyle(
                              color: Color.fromRGBO(196, 75, 75, .8),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          c ?? 'N/A',
                          style: TextStyle(
                              color: Color.fromRGBO(196, 75, 75, 1),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[

                        Text(
                          da == ' ' || da == null
                              ? ' '
                              : (' [' + '+' + da.toString() + ']'),
                          style: TextStyle(
                              color: Color.fromRGBO(48, 100, 255, .8),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          a ?? 'N/A',
                          style: TextStyle(
                              color: Color.fromRGBO(48, 100, 255, 1),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[

                        Text(
                          dr == ' ' || dr == null
                              ? ' '
                              : (' [' + '+' + dr.toString() + ']'),
                          style: TextStyle(
                              color: Color.fromRGBO(12, 138, 37, .8),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          r ?? 'N/A',
                          style: TextStyle(
                              color: Color.fromRGBO(12, 138, 37, 1),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[

                        Text(
                          dd == ' ' || dd == null
                              ? ' '
                              : (' [' + '+' + dd.toString() + ']'),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          d ?? 'N/A',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] ,
          ),
          trailing: IconButton(
              icon:Icon(Icons.arrow_forward, color: Colors.blue)
          ),
          onTap: (){
            _getStateData(context, state);
          },
        ),
      ),
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

    List statewise = data['state'];

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
        body: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 2.0,
                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//
//                    Expanded(
//                      flex:3,
//                      child:Container(
//
//                        color: Colors.black12,
//                        padding: EdgeInsets.only(top:5.0, right:5.0, left:5.0, bottom:5.0),
//                        child: Text(
//                          'STATE/UT',
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontFamily: 'Poppins',
//                            fontWeight: FontWeight.w700,
//                            fontSize: 15.0,
//                          ),
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child:Container(
//                        margin: EdgeInsets.only(left:2.0),
//                        color: Colors.black12,
//                        padding: EdgeInsets.only(top:5.0, right:5.0, left:5.0, bottom:5.0),
//                        child: Text(
//                          'C',
//                          style: TextStyle(
//                            color: Colors.red,
//                            fontFamily: 'Poppins',
//                            fontWeight: FontWeight.w700,
//                            fontSize: 15.0,
//                          ),
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child:Container(
//                        margin: EdgeInsets.only(left:2.0),
//
//                        color: Colors.black12,
//                        padding: EdgeInsets.only(top:5.0, right:5.0, left:5.0, bottom:5.0),
//                        child: Text(
//                          'A',
//                          style: TextStyle(
//                            color: Colors.blue,
//                            fontFamily: 'Poppins',
//                            fontWeight: FontWeight.w700,
//                            fontSize: 15.0,
//                          ),
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child:Container(
//                        color: Colors.black12,
//                        margin: EdgeInsets.only(left:2.0),
//                        padding: EdgeInsets.only(top:5.0, right:5.0, left:5.0, bottom:5.0),
//                        child: Text(
//                          'R',
//                          style: TextStyle(
//                            color: Colors.green,
//                            fontFamily: 'Poppins',
//                            fontWeight: FontWeight.w700,
//                            fontSize: 15.0,
//                          ),
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child:Container(
//                        margin: EdgeInsets.only(left:5.0),
//
//                        color: Colors.black12,
//                        padding: EdgeInsets.only(top:5.0, right:5.0, left:5.0, bottom:5.0),
//                        child: Text(
//                          'D',
//                          style: TextStyle(
//                            color: Colors.black54,
//                            fontFamily: 'Poppins',
//                            fontWeight: FontWeight.w700,
//                            fontSize: 15.0,
//                          ),
//                        ),
//                      ),
//                    ),
//
//
//
//                  ],
//                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: statewise.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ColumnInfo(
                              statewise[i]['state'],
                              statewise[i]['confirmed'],
                              statewise[i]['deltaconfirmed'],
                              statewise[i]['active'],
                              statewise[i]['deltaactive'],
                              statewise[i]['recovered'],
                              statewise[i]['deltarecovered'],
                              statewise[i]['deaths'],
                              statewise[i]['deltadeaths']);
                        })),


              ],
            ),
          ),
        ));
  }
}
