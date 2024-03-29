import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/utils/deviceSize.dart';
import 'package:daikhopk/screens/login_screen.dart';
import 'package:number_display/number_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:rate_my_app/rate_my_app.dart';

List<String> listdataHomeCategories = ['New Episodes','Released Recently','Currently Running','Most Watched - All time','Top Rated - All time'];
late DeviceSize deviceSize;
late SharedPreferences prefs;
late Shows showsHome;
late Show showLocal;
List<HorizontalListData> listdataHome = [];
late Future<bool> dataRequiredforLogin;
bool canAppleLogin = false;

Map <int, Show> lastplayedshows = new Map();
var userlocal = new Map();
late Future<Shows> dataRequiredForHome;

List<String> lastplayedshowidsHome = [];
bool authSignedIn = false;
int errorHome = 0;
bool isWeb = kIsWeb;
bool isIOS = Platform.isIOS;
bool disclaimerShown = false;

String messageTitle = "Empty";
String notificationAlert = "alert";

final numdisplay = createDisplay(
  length: 5,
);

RateMyApp rateMyApp = RateMyApp (
  preferencesPrefix: 'rateMyApp_daikhopk',
  minDays: 3,
  minLaunches: 5,
  remindDays: 3,
  remindLaunches: 5
);

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

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

    if (!isWeb) {
      CheckAppleLogin();
    } else {
      dataRequiredforLogin = Future<bool>.value(true);
    }

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
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
      if (userlocal['accountType'] != 'anonymous') {
        Map <String, dynamic> Json = {
          "uid": userlocal['uid'],
          "stats": [
            {
              "stat": "show_lastplayed"
            },
          ]
        };
        String response = await postUrl($serviceURLgetstats, Json);
        if (response != $nodata) {
          var jsonresult = jsonDecode(response);
          if (jsonresult[0]['show_lastplayed'] != "0") {
            final lastplayed = new Map<String, dynamic>.from(
                jsonresult[0]['show_lastplayed']);
            final lastplayedsorted = new SplayTreeMap<String, dynamic>.from(
                lastplayed, (a, b) => lastplayed[b].compareTo(lastplayed[a]));
            lastplayedshowidsHome = lastplayedsorted.keys.toList();
          }
        }
      }
    }

    showsHome = Shows.fromJson(jsonDecode(featured));
    showsHome.featured.shuffle();

    if(lastplayedshowidsHome.length > 0) {
      lastplayedshows.clear();
      lastplayedshowidsHome.forEach((element) {
        if(showsHome.shows[int.parse(element)] != null) {
          lastplayedshows.putIfAbsent(
              showsHome.shows[int.parse(element)]!.showid, () => showsHome
              .shows[int.parse(element)]!);
        }
      });
    }

    //['New Episodes','Released Recently','Currently Running','Most Watched - All time','Top Rated - All time']
    listdataHome = [];
    for(var i=0; i < listdataHomeCategories.length; i ++) {
      SplayTreeMap<int, Show> sortedshows = SplayTreeMap();
      DateTime currDate = DateTime.now();
      //DateTime currMonth = new DateTime(currDate.year, currDate.month - 1, 1);
      DateTime currMonth = new DateTime(currDate.year - 1, 6, 1);

      if(listdataHomeCategories[i] == "New Episodes") {
        sortedshows = new SplayTreeMap<int, Show>.from(
          showsHome.shows, (a,b) => showsHome.shows[b]!.updateDatetime.compareTo(showsHome.shows[a]!.updateDatetime)
        );
      }
      else if(listdataHomeCategories[i] == "Released Recently") {
        sortedshows = new SplayTreeMap<int, Show>.from(
            showsHome.shows, (a,b) => showsHome.shows[b]!.releaseDatetime.compareTo(showsHome.shows[a]!.releaseDatetime)
        );
      }
      else if(listdataHomeCategories[i] == "Currently Running") {
        sortedshows = new SplayTreeMap<int, Show>.from(
            showsHome.shows, (a,b) => showsHome.shows[b]!.releaseDatetime.compareTo(showsHome.shows[a]!.releaseDatetime)
        );
        showsHome.shows.forEach((key, value) {
          if(showsHome.shows[key]!.completed == 1) {
            sortedshows.remove(key);
          }
        });
      }
      else if(listdataHomeCategories[i] == "Most Watched - All time") {
        sortedshows = new SplayTreeMap<int, Show>.from(
            showsHome.shows, (a,b) => showsHome.shows[b]!.viewCount.compareTo(showsHome.shows[a]!.viewCount)
        );
      }
      else if(listdataHomeCategories[i] == "Top Rated - All time") {
        sortedshows = new SplayTreeMap<int, Show>.from(
            showsHome.shows, (a,b) => showsHome.shows[b]!.likeCount.compareTo(showsHome.shows[a]!.likeCount)
        );
      }
      listdataHome.add(HorizontalListData(listdataHomeCategories[i],sortedshows));
    }

    errorHome = 0;
    return Shows.fromJson(jsonDecode(shows));
  }
  catch(e) {
    errorHome = 1;
    return Shows();
  }
}

Future<void> CheckAppleLogin() async {
  if(Platform.isIOS) {
    // canAppleLogin = await AppleSignIn.isAvailable();
    canAppleLogin = true;
  } else {
    canAppleLogin = false;
  }

  dataRequiredforLogin = Future<bool>.value(true);
}

class HorizontalListData {
  String title;
  Map<int, Show> data;

  HorizontalListData(this.title, this.data);
}
