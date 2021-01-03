import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/widgets/horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/screens/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
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

  @override
  void initState() {
    super.initState();
    print('initState');
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  Future<void> refreshdata() async {
    dataRequiredForHome = fetchDataHome();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Shows>(
      future: dataRequiredForHome,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: $circularbackgroundcolor,
              valueColor: new AlwaysStoppedAnimation<Color>($circularstrokecolor),
              strokeWidth: $circularstrokewidth,
            ),
          );
        } else if (snapshot.hasData && errorHome == 0) {
          return WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    CustomSliverAppBar(
                        shows: snapshot.data.shows,
                        channels: snapshot.data.channels,
                    ),
                  ];
                },
                body: Container(
                  color: Colors.black,
                  child: RefreshIndicator(
                    color: Colors.redAccent,
                    backgroundColor: Colors.black,
                    displacement: 100,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Conditional.single(
                              context: context,
                              conditionBuilder: (BuildContext context) =>
                              ((lastplayedshowidsHome?.length ?? 0) > 0) == true,
                              widgetBuilder: (BuildContext context) =>
                                  Column(
                                      children: <Widget>[
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10),
                                              ),
                                              Text(
                                                'Last Played',
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
                                            shows: showsHome.shows,
                                            channels: showsHome.channels,
                                            filtershowids: lastplayedshowidsHome,
                                          ),
                                        ),
                                      ]
                                  ),
                              fallbackBuilder: (BuildContext context) =>
                                  SizedBox(height: 0.0,),
                            ),
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
                                shows: showsHome.shows,
                                channels: showsHome.channels,
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                signOutGoogle();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    }), ModalRoute.withName('/'));
                              },
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sign Out',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
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
                    onRefresh: refreshdata,
                  ),
                ),
              ),
              bottomNavigationBar: CustomBottomNavBar(),
            ),
          );
        } else {
          return Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget> [
                Text(
                  "An Error Occured - Please check your connection & try again",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                RaisedButton(
                  onPressed: () {
                    refreshdata();
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Refresh',
                      style: TextStyle(
                          fontSize: 25, color: Colors.white),
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
              ]
            )
          );
        }
      },
    );
  }
}