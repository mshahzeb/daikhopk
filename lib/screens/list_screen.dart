import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/episode.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/play_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:daikhopk/constants.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ListScreen extends StatefulWidget {
  final int showid;
  final String showname;
  final String posterUrl;
  final String trailerUrl;
  final String trailerVideoId;
  final int embed;
  final String uid;
  ListScreen({@required final this.showid, final this.showname, final this.posterUrl, final this.trailerUrl, final this.trailerVideoId, final this.embed, final this.uid});

  @override
  _ListScreenState createState() => _ListScreenState(
    showid: showid,
    showname: showname,
    posterUrl: posterUrl,
    trailerUrl: trailerUrl,
    trailerVideoId: trailerVideoId,
    embed: embed,
    uid: uid
  );
}

class _ListScreenState extends State<ListScreen> {
  final int showid;
  final String showname;
  final String posterUrl;
  final String trailerUrl;
  final String trailerVideoId;
  final int embed;
  final String uid;
  int error = 0;
  int _lastplayedepisode;
  Future<Shows> _dataRequiredForBuild;
  List<Episode> _episodes;
  _ListScreenState({@required final this.showid, final this.showname, final this.posterUrl, final this.trailerUrl, final this.trailerVideoId, final this.embed, final this.uid});

  @override
  void initState() {
    super.initState();

    _dataRequiredForBuild = fetchData();
    UpdateShowIdStats();
  }

  Future<Shows> fetchData() async {
    try {
      String episodes = await fetchUrlCached(showid);
      Map<int, Show> shows = Shows
          .fromJson(jsonDecode(episodes))
          .shows;
      _episodes = shows[shows.keys.first].episodes;

      Map <String, dynamic> Json = {
        "uid": uid,
        "stat": "show_lastplayedepi",
        "sid": showid.toString()
      };

      String result = await postUrl($serviceURLgetstats, Json);
      _lastplayedepisode = int.parse(result ?? 0) - 1;

      return Shows.fromJson(jsonDecode(episodes));
    } catch(e) {
      error = 1;
    }
  }

  Future<void> UpdateShowIdStats() async {
    Map <String, dynamic> Json = {
      "uid": uid,
      "stats": [
        {
          "sid": showid.toString(),
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
        title: Text(showname),
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
              children: [
                CachedNetworkImage(
                  imageUrl: posterUrl,
                  width: $defaultWidth,
                ),
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
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _episodes.length,
                                        itemBuilder: (context, index) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayScreen(
                                                          showid: showid,
                                                          showname: showname,
                                                          posterUrl: posterUrl,
                                                          episode: _episodes[_lastplayedepisode],
                                                          uid: uid
                                                      )
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            leading: CachedNetworkImage(
                                              imageUrl: _episodes[_lastplayedepisode]
                                                  ?.episodeThumbnail ?? posterUrl,
                                              width: $defaultWidth,
                                              fit: BoxFit.fitHeight,
                                              alignment: Alignment.topCenter,
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
                                  fallbackBuilder: (BuildContext context) =>
                                  SizedBox(height: 0.0,),
                                ),
                                SizedBox(height: 20.0,),
                                Text(
                                  'Episodes',
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
                                    return GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayScreen(
                                                      showid: showid,
                                                      showname: showname,
                                                      posterUrl: posterUrl,
                                                      episode: _episodes[index],
                                                      uid: uid
                                                  )
                                          ),
                                        );
                                      },
                                      child: ListTile(
                                        leading: CachedNetworkImage(
                                          imageUrl: _episodes[index]
                                              ?.episodeThumbnail ?? posterUrl,
                                          width: $defaultWidth,
                                          fit: BoxFit.fitHeight,
                                          alignment: Alignment.topCenter,
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}