import 'dart:async';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/utils/deviceSize.dart';
import 'package:daikhopk/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';


class Splash extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

DeviceSize deviceSize;

class VideoState extends State<Splash> with SingleTickerProviderStateMixin{

  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authSignedIn = prefs.getBool('auth') ?? false;

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
        vsync: this, duration: new Duration(seconds: 2));
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
