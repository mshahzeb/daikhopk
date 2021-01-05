import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:daikhopk/widgets/play_pause_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:daikhopk/models/episode.dart';
import 'package:daikhopk/constants.dart';

String videoId;
YoutubePlayerController _controller;

class PlayScreen extends StatefulWidget {
  final int showid;
  final String showname;
  final String posterUrl;
  final Episode episode;
  final int embed;
  var client;
  PlayScreen({@required final this.showid, @required final this.showname, @required final this.posterUrl, @required final this.episode, @required final this.embed, @required final this.client});

  @override
  _PlayScreenState createState() => _PlayScreenState(
    showid: showid,
    showname: showname,
    posterUrl: posterUrl,
    episode: episode,
    embed: embed,
    client: client,
  );
}

class _PlayScreenState extends State<PlayScreen> {
  final int showid;
  final String showname;
  final String posterUrl;
  final Episode episode;
  final int embed;
  var client;
  bool played = false;
  _PlayScreenState({@required final this.showid, @required final this.showname, @required final this.posterUrl, @required final this.episode, @required final this.embed, @required final this.client});

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
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
        enableCaption: false,
        enableJavaScript: true,
        desktopMode: kIsWeb,
        autoPlay: true,
        playsInline: true,
        startAt: Duration(seconds: 0)
      ),
    )..listen((value) {
      if (value.isReady && !value.hasPlayed) {
        if(!played) {
          if(embed == 1) {
            _controller.play();
          } else {
            _launchYoutubeVideo(episode.episodeUrl);
          }
          played = true;
        }
        if(_controller.value.error == YoutubeError.sameAsNotEmbeddable) {
          _controller.stop();
          _controller.reset();
          _launchYoutubeVideo(episode.episodeUrl);
        }
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
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.close();
    super.dispose();
  }

  void UpdateVideoIdStats() async {
    double now = new DateTime.now().millisecondsSinceEpoch/1000;
    int nowint = now.toInt();
    String showidstr = showid.toString();
    Map <String, dynamic> Json = {
      "uid": userlocal['uid'],
      "stats": [
        {
          "sid": videoId,
          "stat": "vid_playcounts",
          "val": "inc"
        },
        {
          "sid": videoId,
          "stat": "vid_lastplayed",
          "val": nowint
        },
        {
          "sid": showidstr,
          "stat": "show_playcounts",
          "val": "inc"
        },
        {
          "sid": showidstr,
          "stat": "show_lastplayed",
          "val": nowint
        },
        {
          "sid": showidstr,
          "stat": "show_lastplayedepi",
          "val": episode.episodeno
        }
      ]
    };
    postUrl($serviceURLupdatestats, Json);

    Json = {
      "uid": userlocal['uid'],
      "stat": "vid_lastplaytime",
      "sid": videoId
    };

    String result = await postUrl($serviceURLgetstats, Json);
    int playtime = int.parse(result ?? 0);
    if (playtime < 0) {
      playtime = 0;
    }
    await Future.delayed(Duration(seconds: 2));
    _controller.seekTo(Duration(seconds: playtime));
  }

  void UpdateVideoIdLastPlayTime(int duration) async {
    if(duration > 0) {
      Map <String, dynamic> Json = {
        "uid": userlocal['uid'],
        "stats": [
          {
            "sid": videoId,
            "stat": "vid_lastplaytime",
            "val": duration
          }
        ]
      };
      postUrl($serviceURLupdatestats, Json);
    }
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
                if (kIsWeb && constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: player),
                    ],
                  );
                }
                else {
                  return ListView(
                    children: <Widget> [
                    SizedBox(
                      height: deviceSize.height/2,
                      width: deviceSize.width,
                      child: player,
                    ),
                    Controls(
                      playUrl: episode.episodeUrl,
                    ),
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: (episode?.episodeThumbnail ?? "") == "" ? posterUrl : episode.episodeThumbnail,
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
                    )
                    ]
                  );
                }
              },
            ),
          )
        ),
      ),
    );
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