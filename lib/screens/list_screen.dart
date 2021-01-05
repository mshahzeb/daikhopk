import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/episode.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/models/show.dart';
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
  ListScreen({@required final this.show, final this.channel});

  @override
  _ListScreenState createState() => _ListScreenState(
    show: show,
    channel: channel,
  );
}

class _ListScreenState extends State<ListScreen> {
  final Show show;
  final Channel channel;
  int error = 0;
  int _lastplayedepisode;
  Future<Shows> _dataRequiredForBuild;
  Map<int, Episode> _episodes;
  _ListScreenState({@required final this.show, final this.channel});

  @override
  void initState() {
    super.initState();

    _dataRequiredForBuild = fetchData();
    UpdateShowIdStats();
  }

  Future<Shows> fetchData() async {
    try {
      String episodes = await fetchUrlCached(show.showid);
      Map<int, Show> shows = Shows
          .fromJson(jsonDecode(episodes))
          .shows;
      _episodes = shows[shows.keys.first].episodes;

      Map <String, dynamic> Json = {
        "uid": userlocal['uid'],
        "stat": "show_lastplayedepi",
        "sid": show.showid.toString()
      };

      String result = await postUrl($serviceURLgetstats, Json);
      _lastplayedepisode = int.parse(result ?? -1);

      return Shows.fromJson(jsonDecode(episodes));
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(show.showname),
        actions: <Widget> [
          Container(
              height: 30,
              width: 30,
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
                FutureBuilder<Shows>(
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
                                  (_lastplayedepisode >= 0),
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlayScreen(
                                                            showid: show.showid,
                                                            showname: show.showname,
                                                            posterUrl: show.posterUrl,
                                                            episode: _episodes[_lastplayedepisode],
                                                            embed: show.embed,
                                                        )
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              leading: CachedNetworkImage(
                                                imageUrl: (_episodes[_lastplayedepisode]?.episodeThumbnail ?? "") == "" ? show.posterUrl : _episodes[_lastplayedepisode].episodeThumbnail,
                                                width: 100,
                                                fit: BoxFit.fitWidth,
                                                alignment: Alignment.topLeft,
                                              ),
                                              title: Text(
                                                'Episode ' +
                                                    _episodes[_lastplayedepisode].episodeno
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              subtitle: Text(
                                                _episodes[_lastplayedepisode].episodetitle,
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
                                  itemCount: _episodes.length,
                                  itemBuilder: (context, index) {
                                    index++;
                                    if(_episodes[index] != null) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayScreen(
                                                      showid: show.showid,
                                                      showname: show.showname,
                                                      posterUrl: show.posterUrl,
                                                      episode: _episodes[index],
                                                      embed: show.embed,
                                                    )
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          leading: CachedNetworkImage(
                                            imageUrl: (_episodes[index]
                                                ?.episodeThumbnail ?? "") == ""
                                                ? show.posterUrl
                                                : _episodes[index]
                                                .episodeThumbnail,
                                            width: 100,
                                            fit: BoxFit.fitWidth,
                                            alignment: Alignment.topLeft,
                                          ),
                                          title: Text(
                                            'Episode ' +
                                                _episodes[index].episodeno
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          subtitle: Text(
                                            _episodes[index].episodetitle,
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}