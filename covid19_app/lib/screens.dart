import 'package:flutter/material.dart';
import 'dialog.dart' as dg;
import 'package:covid19_app/api_wrapper.dart' as api;
class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}


final slideList = [
  Slide(
    imageUrl: 'assets/1.jpg',
    title: 'A Cool Way to Get Start',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
  ),
  Slide(
    imageUrl: 'assets/2.jpg',
    title: 'Design Interactive App UI',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
  ),
  Slide(
    imageUrl: 'assets/3.jpg',
    title: 'It\'s Just the Beginning',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
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
      print("inside preform logic method");
      api.Covid19API a = api.Covid19API();
      Map data = await a.login('mornville', 'apple007');


      if (data['status'] == 'success') {
        Map hoiStat = await a.healthStat();
        Map temp = await a.coronaCases();
        print("Fetching successful");
        //Checking if the user is Admin or employee

        Navigator.pushReplacementNamed(context, '/dashboard', arguments: {
          'total':temp['info'], 'hoiStat':hoiStat['info'],
        });
      } else {
        dg.showDialogBox(context, 'Make sure you are connected to the internet.');
      }
    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(40.0),
            color: Color.fromRGBO(85, 85, 85, .7),
            child: MaterialButton(
              minWidth: 150.0,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                _getCorona(context);
              },
              child: Text("Close",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration:  BoxDecoration(
        image: DecorationImage(
          image:   AssetImage(slideList[index].imageUrl),

          fit: BoxFit.cover,
        ),
      ),
    );
  }
}