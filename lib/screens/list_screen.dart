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
    String episodes = await fetchUrlCached(showid);
    Map<int, Show> shows = Shows.fromJson(jsonDecode(episodes)).shows;
    _episodes = shows[shows.keys.first].episodes;
    return Shows.fromJson(jsonDecode(episodes));
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
                    return snapshot.hasData
                    ? SingleChildScrollView (
                        physics: ScrollPhysics(),
                        child: Column(
                          children: <Widget>[
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
                                      MaterialPageRoute(builder: (context) => PlayScreen(
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
                                      imageUrl: _episodes[index]?.episodeThumbnail ?? posterUrl,
                                      width: $defaultWidth,
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.topCenter,
                                    ),
                                    title: Text(
                                      'Episode ' + _episodes[index].episodeno.toString(),
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
                    )
                    : Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
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