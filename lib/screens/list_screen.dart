import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/screens/play_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:daikhopk/constants.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ListScreen extends StatefulWidget {
  final Show show;
  final Channel channel;
  final bool refresh;
  final int lastplayedepisodeLocal;
  final int backroute;

  ListScreen({@required final this.show, @required final this.channel, @required final this.refresh, final this.lastplayedepisodeLocal, final this.backroute});

  @override
  _ListScreenState createState() => _ListScreenState(
    show: show,
    channel: channel,
    refresh: refresh,
    lastplayedepisodeLocal: lastplayedepisodeLocal,
    backroute: backroute,
  );
}

class _ListScreenState extends State<ListScreen> {
  final Show show;
  final Channel channel;
  final bool refresh;
  final int lastplayedepisodeLocal;
  final int backroute;

  int error = 0;
  int _lastplayedepisode;
  Future<Show> _dataRequiredForBuild;
  _ListScreenState({@required final this.show, @required final this.channel, @required final this.refresh, final this.lastplayedepisodeLocal, final this.backroute});

  @override
  void initState() {
    super.initState();

    _dataRequiredForBuild = fetchData();
    UpdateShowIdStats();
  }

  Future<Show> fetchData() async {
    try {
      if(refresh) {
        String episodes = await fetchUrlCached(show.showid);
        Map<int, Show> temp = Shows
            .fromJson(jsonDecode(episodes))
            .shows;
        showLocal = temp[temp.keys.first];

        Map <String, dynamic> Json = {
          "uid": userlocal['uid'],
          "stat": "show_lastplayedepi",
          "sid": show.showid.toString()
        };

        String result = await postUrl($serviceURLgetstats, Json);
        _lastplayedepisode = int.parse(result ?? -1);

        return show;
      } else {
        _lastplayedepisode = lastplayedepisodeLocal;
        return show;
      }
    } catch(e) {
      error = 1;
    }
  }

  Future<void> UpdateShowIdStats() async {
    Map <String, dynamic> Json = {
      "uid": userlocal['uid'],
      "stats": [
        {
          "sid": show.showid.toString(),
          "stat": "show_clicks",
          "val": "inc"
        }
      ]
    };
    postUrl($serviceURLupdatestats, Json);
  }

  void refreshdata() {
    _dataRequiredForBuild = fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async {
        if(backroute == 1) {
          return true;
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(
                        refresh: false,
                      )
              )
          );
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(show.showname),
          actions: <Widget> [
            Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.only(right: 10),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: channel.logoUrl,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.topLeft,
                  ),
                )
            ),
          ]
        ),
        body: Container(
          color: Colors.black,
          child: ListView(
                children: [
                  CachedNetworkImage(
                    imageUrl: show.posterUrl,
                    height: deviceSize.height/3,
                    width: deviceSize.width,
                    fit:BoxFit.cover,
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget> [
                      Container(
                          height: 50,
                          width: 100,
                          child: Center(
                            child: Text(
                              'Episodes\n' + show.totalepisodes.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ),
                      Container(
                          height: 50,
                          width: 100,
                          child: Center(
                            child: Text(
                              'Released\n' + show.releaseYear.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ),
                      Container(
                          height: 50,
                          width: 100,
                          child: Center(
                            child: Text(
                              'Views\n' + numdisplay(show.viewCount),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<Show>(
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
                                  Conditional.single(
                                    conditionBuilder: (BuildContext context) =>
                                    (_lastplayedepisode > 0),
                                    widgetBuilder: (BuildContext context) =>
                                      ListView(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        children: <Widget> [
                                          Text(
                                            'Continue Watching',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: 1,
                                            itemBuilder: (context, index) {
                                            return GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () {
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlayScreen(
                                                              show: showLocal,
                                                              channel: channel,
                                                              episodeno: _lastplayedepisode
                                                          )
                                                  ),
                                                );
                                              },
                                              child: ListTile(
                                                leading: CachedNetworkImage(
                                                  imageUrl: (showLocal.episodes[_lastplayedepisode]?.episodeThumbnail ?? "") == "" ? show.posterUrl : showLocal.episodes[_lastplayedepisode].episodeThumbnail,
                                                  width: 100,
                                                  fit: BoxFit.fitWidth,
                                                  alignment: Alignment.topLeft,
                                                ),
                                                title: Text(
                                                  'Episode ' +
                                                      showLocal.episodes[_lastplayedepisode].episodeno
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                subtitle: Text(
                                                  showLocal.episodes[_lastplayedepisode].episodetitle,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            );
                                          }
                                        ),
                                      ]
                                    ),
                                    fallbackBuilder: (BuildContext context) =>
                                    SizedBox(height: 0.0,),
                                  ),
                                  SizedBox(height: 20.0,),
                                  Text(
                                    'All Episodes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: showLocal.episodes.length,
                                    itemBuilder: (context, index) {
                                      index++;
                                      if(showLocal.episodes[index] != null) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayScreen(
                                                          show: showLocal,
                                                          channel: channel,
                                                          episodeno: index
                                                      )
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            leading: CachedNetworkImage(
                                              imageUrl: (showLocal.episodes[index]
                                                  ?.episodeThumbnail ?? "") == ""
                                                  ? show.posterUrl
                                                  : showLocal.episodes[index]
                                                  .episodeThumbnail,
                                              width: 100,
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.topLeft,
                                            ),
                                            title: Text(
                                              'Episode ' +
                                                  showLocal.episodes[index].episodeno
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            subtitle: Text(
                                              showLocal.episodes[index].episodetitle,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.left,
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
                ],
              ),
          ),
        bottomNavigationBar: CustomBottomNavBar(currentscreen: "List",),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}