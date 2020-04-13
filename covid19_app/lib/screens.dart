import 'package:flutter/material.dart';
import 'dialog.dart' as dg;
import 'package:covid19_app/api_wrapper.dart' as api;
class Slide {
  final String imageUrl;
  final String title;
  final String description;
  final String line1;
  final String line2;
  final String line3;



  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
      this.line1,
      this.line2,
      this.line3,

  });
}


final slideList = [
  Slide(
    imageUrl: 'assets/1.jpg',
    title: 'Amidst the Covid19 pandemic, we at Podnet have decided to contribute to help to prevent the spread of deadly coronavirus by creating a nationwide database.',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
  ),
  Slide(
    imageUrl: 'assets/2.jpg',
    title: 'How can it help?',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
    line1: 'Channelize the sanitization efforts.',
    line2: 'Create a hyperlocal map of symtomatic patients.'
      ,
    line3: 'Help forcast the next outbreak.'
  ),
  Slide(
    imageUrl: 'assets/3.jpg',
    title: 'What can you do?',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
      line1: 'Navigate to \'Record Health\' button in the app.',
      line2: 'Answer simple questions about your health.'
      ,
      line3: 'Update your health data periodically.'
  ),
];

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}


class SlideItem extends StatelessWidget {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final int index;
  SlideItem(this.index);
  Future<void> _getCorona(BuildContext context) async {
    try {
      dg.Dialogs.showLoadingDialog(context, _keyLoader); //invoking login

      print("inside preform logic method");
      api.Covid19API a = api.Covid19API();
      Map data = await a.login('mornville', 'apple007');


      if (data['status'] == 'success') {
        Map hoiStat = await a.healthStat();
        Map temp = await a.coronaCases();
        print("Fetching successful");
        Navigator.pop(context);

        Navigator.pushReplacementNamed(context, '/dashboard', arguments: {
          'total':temp['info'], 'hoiStat':hoiStat['info'],
        });
      } else {
        Navigator.pop(context); //close the dialogue
        dg.showDialogBox(
            context, 'Make sure you are connected to the internet.');
      }
    } catch (error) {
      print(error);
    }
  }



  @override
  Widget build(BuildContext context) {
    return index==0?Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              width: 100.0,
              height: 100.0,
              decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          "assets/p.png")
                  )
              )),
         Padding(
           padding: EdgeInsets.only(left:20.0, right: 20.0),
           child:  Center(
             child: Text(
               slideList[index].title,
               textAlign: TextAlign.center,
               style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'Montserrat'),
             ),
           ),
         ),
          Material(
            elevation: 1.0,
            borderRadius: BorderRadius.circular(40.0),
            color: Color.fromRGBO(85, 85, 85, .7),
            child: MaterialButton(
              minWidth: 100.0,
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              onPressed: () {
                _getCorona(context);
              },
              child: Text("Close",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
            ),
          ),


        ],
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration:  BoxDecoration(
        color: Color.fromRGBO(26, 44, 87, 1)
        ),

    ):Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              width: 100.0,
              height: 100.0,
              decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          "assets/p.png")
                  )
              )),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:20.0, right: 20.0, bottom: 5.0),
              child:  Center(
                child: Text(
                  slideList[index].title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'Montserrat'),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 50.0,
                child: Divider(),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(left:40.0, right:40.0, bottom:15.0),
              child: Text(
                slideList[index].line1,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Montserrat'),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white,),
            Padding(
              padding: EdgeInsets.only(left:40.0, right:40.0, bottom:15.0, top:10.0),
              child: Text(
                slideList[index].line2,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Montserrat'),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white,),
            Padding(
              padding: EdgeInsets.only(left:40.0, right:40.0, bottom:15.0,top:10.0),
              child: Text(
                slideList[index].line3,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Montserrat'),
              ),
            ),

          ],
        ),
          Material(
            elevation: 1.0,
            borderRadius: BorderRadius.circular(40.0),
            color: Color.fromRGBO(85, 85, 85, .7),
            child: MaterialButton(
              minWidth: 100.0,
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              onPressed: () {
                _getCorona(context);
              },
              child: Text("Close",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
            ),
          ),

        ],
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration:  BoxDecoration(
          color: Color.fromRGBO(26, 44, 87, 1)
      ),

    );
  }
}