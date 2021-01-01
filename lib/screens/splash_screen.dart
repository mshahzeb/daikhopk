import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/utils/deviceSize.dart';
import 'package:daikhopk/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'package:daikhopk/models/shows.dart';

DeviceSize deviceSize;
SharedPreferences prefs;
String uidlocal;
var client;
int errorHome = 0;
Future<Shows> dataRequiredForHome;
Shows showsHome;
List<String> lastplayedshowidsHome;
bool authSignedIn;

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
      uidlocal = prefs.getString('uid');
    }
    client = http.Client();
    dataRequiredForHome = fetchDataHome();

    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    if (authSignedIn == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
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
              width: animation.value * 250,
              height: animation.value * 250,
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
        "uid": uidlocal,
        "stat": "show_lastplayed"
      };
      String result = await postUrl($serviceURLgetstats, Json);
      if (result != $nodata) {
        Map<String, dynamic> lastplayed = jsonDecode(result);
        final lastplayedsorted = new SplayTreeMap<String, dynamic>.from(
            lastplayed, (a, b) => lastplayed[b].compareTo(lastplayed[a]));
        lastplayedshowidsHome = lastplayedsorted.keys.toList();
      }
    }

    showsHome = Shows.fromJson(jsonDecode(featured));
    return Shows.fromJson(jsonDecode(shows));
  }
  catch(e) {
    errorHome = 1;
  }
}
