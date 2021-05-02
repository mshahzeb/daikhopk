import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/widgets/horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:daikhopk/widgets/custom_sliver_app_bar.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  final bool refresh;
  HomeScreen({required final this.refresh});

  @override
  _HomeScreenState createState() => _HomeScreenState(
      refresh: refresh
  );
}

class _HomeScreenState extends State<HomeScreen> {
  final bool refresh;
  _HomeScreenState({required final this.refresh});

  @override
  void initState() {
    super.initState();

    if(refresh) {
      refreshdata();
    }

    disclaimerShown = prefs.getBool('disclaimerShown') ?? false;
    if(!disclaimerShown) {
      Future.delayed(Duration.zero, () {
        this._showDisclaimer(context);
      });
    }

    print('initState');
  }

  @override
  void dispose() {
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

  void _showDisclaimer(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.redAccent)),
          backgroundColor: Colors.black,
          scrollable: true,
          title: Text(
            'daikho.pk\n\nDISCLAIMER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Text(
            $disclaimer,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(
                  right: 10.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  prefs.setBool('disclaimerShown',true);
                },
                child: Text(
                  'I Understand',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )
    );
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
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black,
                body: NestedScrollView(
                  headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                         CustomSliverAppBar(
                              featured: showsHome.featured,
                            ),
                      ];
                  },
                  body: Container(
                    margin: EdgeInsets.all(10),
                    color: Colors.black,
                    child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) =>
                                ((lastplayedshowidsHome.length) > 0) == true,
                                widgetBuilder: (BuildContext context) =>
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    fontSize: 18,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: $defaultHeight + 70,
                                            child: HorizontalList(
                                              shows: lastplayedshows,
                                              channels: showsHome.channels,
                                              order: true,
                                            ),
                                          ),
                                        ]
                                    ),
                                fallbackBuilder: (BuildContext context) =>
                                    SizedBox(height: 0.0,),
                              ),
                              for (var i=0; i<listdataHomeCategories.length; i++)
                                Conditional.single(
                                  context: context,
                                  conditionBuilder: (BuildContext context) =>
                                  listdataHome[i].data.length > 0,
                                  widgetBuilder: (BuildContext context) =>
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                ),
                                                Text(
                                                  listdataHome[i].title,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: $defaultHeight + 70,
                                            child: HorizontalList(
                                              shows: listdataHome[i].data,
                                              channels: showsHome.channels,
                                              order: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                  fallbackBuilder: (BuildContext context) =>
                                      SizedBox(height: 0.0,),
                                ),
                            ],
                          ),
                        ]
                    ),
                  ),
                ),
                bottomNavigationBar: CustomBottomNavBar(currentscreen: "Home",),
              ),
           ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget> [
                  Image.asset(
                    $iconpath,
                    height: 200,
                  ),
                  SizedBox(height: 100),
                  Image.asset(
                    $problempath,
                    height: 50,
                  ),
                  SizedBox(height: 25),
                  Text(
                    "An Error Occured\n" + "Please check your connection & try again",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.5,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Align(
                    child:ElevatedButton(
                      onPressed: () {
                        refreshdata();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Refresh',
                          style: TextStyle(
                            fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          );
        }
      },
    );
  }
}