import 'dart:convert';

import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:daikhopk/widgets/horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/screens/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:daikhopk/utils/authentication.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:daikhopk/widgets/custom_sliver_app_bar.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<Shows> _dataRequiredForBuild;
  Shows _shows;

  @override
  void initState() {
    super.initState();
    print('initState');

    _dataRequiredForBuild = fetchData();

    print(_dataRequiredForBuild);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Shows> fetchData() async {
    String featured = await fetchUrlCached($shownamescode);
    String shows = await fetchUrlCached($showfeaturedcode);

    _shows = Shows.fromJson(jsonDecode(featured));
    return Shows.fromJson(jsonDecode(shows));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.white,
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Shows>(
      future: _dataRequiredForBuild,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? WillPopScope(
                onWillPop: _onBackPressed,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        CustomSliverAppBar(
                          shows:
                            snapshot.data.shows
                        ),
                      ];
                    },
                    body: Container(
                      color: Colors.black,
                      child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      Text(
                                        'Shows',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 200.0,
                                  child: HorizontalList(
                                    shows:
                                      _shows.shows,
                                  ),
                                ),
                                SizedBox(height: 80),
                                RaisedButton(
                                  onPressed: () {
                                    signOutGoogle();
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginScreen();}), ModalRoute.withName('/'));
                                  },
                                  color: Colors.black,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Sign Out',
                                      style: TextStyle(fontSize: 25, color: Colors.white),
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                )
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                  bottomNavigationBar: CustomBottomNavBar(),
                ),
              )
            : Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
        },
    );
  }
}