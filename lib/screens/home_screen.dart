import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/widgets/horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:daikhopk/widgets/custom_sliver_app_bar.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  final bool refresh;
  HomeScreen({@required final this.refresh});

  @override
  _HomeScreenState createState() => _HomeScreenState(
      refresh: refresh
  );
}

class _HomeScreenState extends State<HomeScreen> {
  final bool refresh;
  _HomeScreenState({@required final this.refresh});

  @override
  void initState() {
    super.initState();

    if(refresh) {
      refreshdata();
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
                resizeToAvoidBottomInset: false,
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
                                ((lastplayedshowidsHome?.length ?? 0) > 0) == true,
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
                                              shows: showsHome.shows,
                                              channels: showsHome.channels,
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