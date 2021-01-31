import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/utils/deviceSize.dart';
import 'package:daikhopk/screens/login_screen.dart';
import 'package:number_display/number_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:daikhopk/models/shows.dart';

List<String> listdataHomeCategories = ['New Episodes','Released This Month','Most Watched','Top Rated'];
DeviceSize deviceSize;
SharedPreferences prefs;
Shows showsHome;
Show showLocal;
List<HorizontalListData> listdataHome;

var userlocal = new Map();
Future<Shows> dataRequiredForHome;

List<String> lastplayedshowidsHome;
bool authSignedIn;
int errorHome = 0;

final numdisplay = createDisplay(
  length: 5,
);

class Splash extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Splash> with SingleTickerProviderStateMixin{

  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    prefs = await SharedPreferences.getInstance();
    authSignedIn = prefs.getBool('auth') ?? false;
    if(authSignedIn) {
      userlocal.putIfAbsent('uid', () => prefs.getString('uid'));
      userlocal.putIfAbsent('name', () => prefs.getString('name'));
      userlocal.putIfAbsent('userEmail', () => prefs.getString('userEmail'));
      userlocal.putIfAbsent('userImageUrl', () => prefs.getString('userImageUrl'));
      userlocal.putIfAbsent('accountType', () => prefs.getString('accountType'));
    }
    dataRequiredForHome = fetchDataHome();

    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    if (authSignedIn == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(refresh: false)), (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });

    startTime();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = DeviceSize(
      size: MediaQuery.of(context).size,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      aspectRatio: MediaQuery.of(context).size.aspectRatio);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            new Image.asset(
              $logopath,
              width: 500,
              height: 500,
            ),
          ],
          ),
        ],
      ),
    );
  }
}

Future<Shows> fetchDataHome() async {
  try {
    String shows = await fetchUrlCached($shownamescode);
    String featured = shows;

    if(authSignedIn) {
      Map <String, dynamic> Json = {
        "uid": userlocal['uid'],
        "stats": [
          {
            "stat": "show_lastplayed"
          }
        ]
      };
      String response = await postUrl($serviceURLgetstats, Json);
      if (response != $nodata) {
        var jsonresult = jsonDecode(response);
        final lastplayed = new Map<String, dynamic>.from(jsonresult[0]['show_lastplayed']);
        print('debug');
        final lastplayedsorted = new SplayTreeMap<String, dynamic>.from(
            lastplayed, (a, b) => lastplayed[b].compareTo(lastplayed[a]));
        lastplayedshowidsHome = lastplayedsorted.keys.toList();
      }
    }

    showsHome = Shows.fromJson(jsonDecode(featured));

    //['New Episodes','Released This Month','Most Watched','Top Rated']
    listdataHome = List();
    for(var i=0; i < listdataHomeCategories.length; i ++) {
      SplayTreeMap<int, Show> sortedshows;
      DateTime currDate = DateTime.now();
      DateTime currMonth = new DateTime(currDate.year, currDate.month - 1, 1);

      if(listdataHomeCategories[i] == "New Episodes") {
        sortedshows = new SplayTreeMap<int, Show>.from(
          showsHome.shows, (a,b) => showsHome.shows[b].releaseDatetime.compareTo(showsHome.shows[a].releaseDatetime)
        );
      }
      else if(listdataHomeCategories[i] == "Released This Month") {
        sortedshows = new SplayTreeMap<int, Show>.from(showsHome.shows);
        showsHome.shows.forEach((key, value) {
          if(showsHome.shows[key].releaseDatetime.isBefore(currMonth)) {
            sortedshows.remove(key);
          }
        });
      }
      else if(listdataHomeCategories[i] == "Most Watched") {
        sortedshows = new SplayTreeMap<int, Show>.from(
            showsHome.shows, (a,b) => showsHome.shows[b].viewCount.compareTo(showsHome.shows[a].viewCount)
        );
      }
      else if(listdataHomeCategories[i] == "Top Rated") {
        sortedshows = new SplayTreeMap<int, Show>.from(
            showsHome.shows, (a,b) => showsHome.shows[b].likeCount.compareTo(showsHome.shows[a].likeCount)
        );
      }
      listdataHome.add(HorizontalListData(listdataHomeCategories[i],sortedshows));
    }

    return Shows.fromJson(jsonDecode(shows));
  }
  catch(e) {
    errorHome = 1;
  }
}


class HorizontalListData {
  String title;
  Map<int, Show> data;

  HorizontalListData(this.title, this.data);
}
