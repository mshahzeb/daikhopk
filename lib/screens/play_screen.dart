import 'dart:developer';
import 'package:daikhopk/utils/rtdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:daikhopk/widgets/play_pause_button_bar.dart';
import 'package:daikhopk/models/episode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/constants.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:http/http.dart';

String uid;
String videoId;
SharedPreferences prefs;

YoutubePlayerController _controller;

class PlayScreen extends StatefulWidget {
  final String showname;
  final String posterUrl;
  final Episode episode;
  PlayScreen({@required final this.showname, final this.posterUrl, final this.episode});

  @override
  _PlayScreenState createState() => _PlayScreenState(
    showname: showname,
    posterUrl: posterUrl,
    episode: episode,
  );
}

class _PlayScreenState extends State<PlayScreen> {
  final String showname;
  final String posterUrl;
  final Episode episode;
  _PlayScreenState({@required  final this.showname, final this.posterUrl, final this.episode});

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if(episode.episodeVideoId == null)
      videoId = YoutubePlayerController.convertUrlToId(episode.episodeUrl);
    else
      videoId = episode.episodeVideoId;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: kIsWeb,
        autoPlay: true,
        playsInline: true,
        startAt: Duration(seconds: 0),
      ),
    )..listen((value) {
      if (value.isReady && !value.hasPlayed) {
        _controller
          ..hidePauseOverlay()
          ..hideTopMenu();
        _controller.play();
      }
    });

    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      Future.delayed(const Duration(seconds: 1), () {
        _controller.play();
      });
      Future.delayed(const Duration(seconds: 5), () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      });
      log('Exited Fullscreen');
    };

    UpdateVideoIdStats();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: WillPopScope(
        onWillPop: ()async {
          UpdateVideoIdLastPlayTime(_controller.value.position.inSeconds);
          Navigator.of(context).pop(true);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Play Video'),
          ),
            body: Container(
              color: Colors.black,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ListView(
                    children: [
                      player,
                      Controls(
                        playUrl: episode.episodeUrl,
                      ),
                      ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: posterUrl,
                          width: $defaultWidth,
                        ),
                        title: Text(
                          'Episode ' + episode.episodeno.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          episode.episodetitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                );
              },
            ),
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class Controls extends StatelessWidget {
  final String playUrl;

  Controls({@required final this.playUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          PlayPauseButtonBar(
              playUrl: playUrl
          ),
          RaisedButton(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(3.0),
                side: BorderSide(color: Colors.white)),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.alternate_email,
                  color: Colors.white,
                  size: 28,
                ),
                Text(
                  "Open in Youtube",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Confortaa',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                  ),
                ),
              ],
            ),
            onPressed: () {
              String launchUrl;
              launchUrl = playUrl + '&t=' + _controller.value.position.inSeconds.toString();
              _launchYoutubeVideo(launchUrl);
            },
          ),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

void UpdateVideoIdStats() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  uid = prefs.getString('uid');

  DateTime now = new DateTime.now();
  List<String> stats = ["vid_playcounts", "vid_lastplayed", "show_playcounts", "show_lastplayed"];
  List<dynamic> vals = ["inc", now.toString(), "inc", now.toString()];

  updateStat(uid, videoId, stats, vals);
  //updateStat(uid, "vid_playcounts", videoId, "inc");
  //updateStat(uid, "vid_lastplayed", videoId, now.toString());

  String result = await getStat(uid,  videoId, "vid_lastplaytime");
  int playtime = int.parse(result ?? 0);
  if (playtime < 0) {
    playtime = 0;
  }
  await Future.delayed(Duration(seconds: 1));
  _controller.seekTo(Duration(seconds: playtime));
}

void UpdateVideoIdLastPlayTime(int duration) async {
  List<String> stats = ["vid_lastplaytime"];
  List<dynamic> vals = [duration];
  updateStat(uid, videoId, stats, vals);
}

Future<void> _launchYoutubeVideo(String _youtubeUrl) async {
  if (_youtubeUrl != null && _youtubeUrl.isNotEmpty) {
    if (await canLaunch(_youtubeUrl)) {
      final bool _nativeAppLaunchSucceeded = await launch(
        _youtubeUrl,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!_nativeAppLaunchSucceeded) {
        await launch(_youtubeUrl, forceSafariVC: true);
      }
    }
  }
}