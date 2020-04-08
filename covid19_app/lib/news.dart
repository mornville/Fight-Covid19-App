import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:covid19_app/api_wrapper.dart' as api;
import 'dialog.dart' as dg;

//Card Widget

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  openBrowserTab(url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: Colors.black);
  }

  void initState() {
    super.initState();
  }

  bool _loaded = false;
  List combine(List ans, List temp) {
    int i;
    for (i = 0; i < temp.length; i++) {
      ans.add(temp[i]);
    }
    return ans;
  }

  //bottomDrawer
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
                          'assets/user.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'My Profile',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {}),
                ListTile(
                    leading: Padding(
                        child: Image.asset(
                          'assets/user.png',
                          height: 30.0,
                        ),
                        padding: EdgeInsets.only(
                            top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
                    title: Text(
                      'My Profile',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {}),
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
                      'News Board',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    onTap: () {
                      openBrowserTab("https://covid19.thepodnet.com/news/");
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
    List temp1 = data['news']['Google News'];
    List temp2 = data['news']['BBC News'];
    List temp3 = data['news']['The Times of India'];
    List temp4 = data['news']['CNBC'];

    List temp = List();
    temp = combine(temp, temp1);
    temp = combine(temp, temp2);
    temp = combine(temp, temp3);
    temp = combine(temp, temp4);

    print(temp.length);

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
          leading: Container(),
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
                onPressed: () =>
                    openBrowserTab("https://covid19.thepodnet.com/maps/"),
                child: Padding(
                    child: Image.asset(
                      'assets/address.png',
                      height: 30.0,
                    ),
                    padding: EdgeInsets.only(
                        top: 8.0, left: 0.0, right: 8.0, bottom: 10.0)),
              ),
              FlatButton(
                onPressed: () {},
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
                    itemCount: temp.length,
                    itemBuilder: (BuildContext context, int i) {
                      if (i == temp.length) {
                        setState(() {
                          _loaded = true;
                        });
                      }

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
                                        child: FadeInImage(
                                            image: NetworkImage(
                                              temp[i]['urlToImage'],
                                            ),
                                            fit: BoxFit.fill,
                                            placeholder: AssetImage(
                                                'assets/loading.gif'))),
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
                                          temp[i]['title'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'OpenSans',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          temp[i]['description'],
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
                                              temp[i]['source']['name'] +
                                                  ' - ' +
                                                  temp[i]['publishedAt']
                                                      .substring(
                                                          0,
                                                          temp[i]['publishedAt']
                                                              .indexOf('T')),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.more, color: Colors.blue,),
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
