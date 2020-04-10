import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'dialog.dart' as dg;
//Card Widget

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Map news = Map();

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }
  void initState() {
    super.initState();
  }

  List combine(List ans, List temp) {
    int i, j;
    for(i=0;i<temp.length;i++){
      for(j=0;j<temp[i].length;j++){
        ans.add(temp[i][j]);
      }
    }
    return ans;
  }
  Future<void> _getNews(BuildContext context) async {
    try {
      Navigator.pop(context);
      dg.Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside getNews");
      api.Covid19API a = api.Covid19API();
      Map data = await a.login('mornville', 'apple007');
      if (data['status'] == 'success') {
        Map hoiStat = await a.getNews();
        news = hoiStat['info'];
        Navigator.pop(context);
//Checking if the user is Admin or employee
        Navigator.pushNamed(context, '/news',
            arguments: {'news': news}); //close the dialogue

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

  openBrowserTab(url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: Colors.black);
  }  //bottomDrawer
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[

                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/address.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'Check Patients on Map',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      openBrowserTab("https://covid19.thepodnet.com/maps/");
                    }),
                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/news.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'News Related to COVID-19',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      _getNews(context);
                    }),


                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/edit.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'Record My Health',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/reportHealth');
                    }),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
    List temp2 = data['news'].values.toList();
    List news = List();
    news = combine(news, temp2);


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "News Related To COVID-19",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15.0,
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
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: Icon(Icons.edit_location),
          label: Text(
            'Report Health',
            style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 0.0),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/reportHealth');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () =>{},
                child: Padding(
                    child: Image.asset(
                      'assets/address.png',
                      height: 30.0,
                    ),
                    padding: EdgeInsets.only(
                        top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
              ),
              FlatButton(
                onPressed: () {
                  _settingModalBottomSheet(context);

                },
                child: Padding(
                    child: Image.asset(
                      'assets/trail.png',
                      height: 30.0,
                    ),
                    padding: EdgeInsets.only(
                        top: 8.0, left: 8.0, right: 0.0, bottom: 10.0)),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (BuildContext context, int i) {


                      return Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                        child: news[i]['urlToImage']!=null?Image.network(news[i]['urlToImage']):Image.network('https://www.barcelonabeta.org/sites/default/files/2018-04/default-image.png'),
                                       ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10.0,
                                        left: 14.0,
                                        right: 14.0,
                                        bottom: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          news[i]['title'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'OpenSans',
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          news[i]['description'] ?? 'N/A',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: 'OpenSans',
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              news[i]['source']['name'] +
                                                  ' - ' +
                                                  news[i]['publishedAt']
                                                      .substring(
                                                          0,
                                                      news[i]['publishedAt']
                                                              .indexOf('T')),
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                           IconButton(
                                             icon: Icon(Icons.play_circle_filled, color:Colors.blue),
                                             onPressed: (){
                                               openBrowserTab(news[i]['url']);
                                             },
                                           ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              )),
                        ),
                      );
                    }))
          ],
        ));
  }
}
