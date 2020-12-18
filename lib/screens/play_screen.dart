import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    UpdateVideoIdStats();

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
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

void UpdateVideoIdStats() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  uid = prefs.getString('uid');

  Map <String, dynamic> Json = {
    "uid": uid,
    "stat": "lastplaytime",
    "videoId": videoId
  };

  Response result = await postUrl($serviceURLgetvideoidstats, Json);
  int playtime = (int.parse(result.body) ?? 0);
  _controller.seekTo(Duration(seconds: playtime));

  Json = {
    "uid": uid,
    "stat": "playcounts",
    "videoId": videoId,
    "value": 1,
    "op": 1
  };

  postUrl($serviceURLupdatevideoidstats, Json);

  DateTime now = new DateTime.now();
  Json = {
    "uid": uid,
    "stat": "lastplayed",
    "videoId": videoId,
    "value": now.toString(),
    "op": 0
  };

  postUrl($serviceURLupdatevideoidstats, Json);
}

void UpdateVideoIdLastPlayTime(int duration) async {
  Map <String, dynamic> Json = {
    "uid": uid,
    "stat": "lastplaytime",
    "videoId": videoId,
    "value": duration,
    "op": 0
  };

  postUrl($serviceURLupdatevideoidstats, Json);
}