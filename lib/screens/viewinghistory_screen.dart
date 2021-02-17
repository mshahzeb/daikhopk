import 'dart:collection';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'list_screen.dart';

class ViewingHistoryScreen extends StatefulWidget {
  @override
  _ViewingHistoryScreenState createState() => new _ViewingHistoryScreenState();
}

class _ViewingHistoryScreenState extends State<ViewingHistoryScreen> {

  Future<int> _dataRequiredForBuild;
  List<String> lastplayedvideos = List();
  List<dynamic> lastplayedvideostimes = List();
  int error = 0;

  @override
  void initState() {
    super.initState();

    _dataRequiredForBuild = fetchData();
  }

  Future<int> fetchData() async {
    try {
      Map <String, dynamic> Json = {
        "uid": userlocal['uid'],
        "stats": [
          {
            "stat": "vid_lastplayed"
          },
        ]
      };
      String response = await postUrl($serviceURLgetstats, Json);
      if (response != $nodata) {
        var jsonresult = jsonDecode(response);
        if(jsonresult[0]['vid_lastplayed'] != "0") {
          final lastplayed = new Map<String, dynamic>.from(
              jsonresult[0]['vid_lastplayed']);
          final lastplayedsorted = new SplayTreeMap<String, dynamic>.from(
              lastplayed, (a, b) => lastplayed[b].compareTo(lastplayed[a]));
          lastplayedvideos = lastplayedsorted.keys.toList();
          lastplayedvideostimes = lastplayedsorted.values.toList();
          return 1;
        }
      }
    } catch(e) {
      error = 1;
    }
  }

  void refreshdata() {
    _dataRequiredForBuild = fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'Viewing History',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<int>(
        future: _dataRequiredForBuild,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: $circularbackgroundcolor,
                valueColor: new AlwaysStoppedAnimation<Color>($circularstrokecolor),
                strokeWidth: $circularstrokewidth,
              ),
            );
          } else if (snapshot.hasData && error == 0) {
            return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 50,),
                          Column(
                              children: [
                                Text(
                                  'Shows\nWatched\n',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      lastplayedshowidsHome.length.toString(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]
                          ),
                          Spacer(),
                          Column(
                              children: [
                                Text(
                                  'Episodes\nWatched\n',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      lastplayedvideos.length.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]
                          ),
                          Spacer(),
                          Column(
                              children: [
                                Text(
                                  'Viewing\nHours\n',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '150',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]
                          ),
                          SizedBox(width: 50,),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Recently Played Videos',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: lastplayedvideos.length,
                        itemBuilder: (context, index) {
                          int showid = int.parse(lastplayedvideos[index].split('_')[0]);
                          int seasonno = int.parse(lastplayedvideos[index].split('_')[1]);
                          int episodeno = int.parse(lastplayedvideos[index].split('_')[2]);
                          String formattedDatetime = DateFormat("yyyy MMM d - hh:mm a").format(DateTime.parse(lastplayedvideostimes[index]));

                          if(showsHome.shows[showid] != null) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListScreen(
                                            show: showsHome.shows[showid],
                                            channel: showsHome.channels[showsHome.shows[showid].channel],
                                            refresh: true,
                                            backroute: 1,
                                          )
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: showsHome.shows[showid].posterUrl,
                                    width: 100,
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topLeft,
                                  ),
                                  title: Text(
                                    showsHome.shows[showid].showname + ' ' + 'Episode ' + episodeno.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text(
                                      formattedDatetime,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffaaaaaa),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(height: 0,);
                          }
                        },
                      ),
                    ]
                )
            );
          }
          else {
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
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "ViewingHistory",),
    );
  }
}