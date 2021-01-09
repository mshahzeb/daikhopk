import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:daikhopk/constants.dart';

import 'list_screen.dart';

String videoId;
YoutubePlayerController _controller;

class PlayScreen extends StatefulWidget {
  final Show show;
  final Channel channel;
  final int episodeno;
  PlayScreen({@required final this.show, @required final this.channel, @required final this.episodeno});

  @override
  _PlayScreenState createState() => _PlayScreenState(
    show: show,
    episodeno: episodeno,
    channel: channel
  );
}

class _PlayScreenState extends State<PlayScreen> {
  final Show show;
  final Channel channel;
  final int episodeno;

  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  bool played = false;
  int pos1 = 0;
  int pos2 = 0;
  int timeleft = 0;
  int nextepisode;
  int previousepisode;
  bool completed = false;

  _PlayScreenState({@required final this.show, @required this.channel, @required final this.episodeno});

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if(show.episodes[episodeno].episodeVideoId == null)
      videoId = YoutubePlayerController.convertUrlToId(show.episodes[episodeno].episodeUrl);
    else
      videoId = show.episodes[episodeno].episodeVideoId;

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
          if(show.embed == 1) {
            _controller.play();
          } else {
            _launchYoutubeVideo(show.episodes[episodeno].episodeUrl);
          }
          played = true;
        }
        if(_controller.value.error == YoutubeError.sameAsNotEmbeddable) {
          _controller.stop();
          _controller.reset();
          _launchYoutubeVideo(show.episodes[episodeno].episodeUrl);
        }
      }
      if(nextepisode != null && played && (value.metaData.duration.inSeconds > 0) && (value.position.inSeconds >= (value.metaData.duration.inSeconds - 10))) {
        pos1 = value.position.inSeconds;
        if(pos1 != pos2) {
          pos2 = pos1;
          timeleft = value.metaData.duration.inSeconds - pos1;
          if(timeleft == 10 || timeleft == 5) {
            ShowSnackBarMessage('Next Episode in ' + timeleft.toString() + ' seconds', 4000);
          } else if(timeleft == 0) {
            ShowSnackBarMessage('Playing Next Episode', 5000);
            ChangeEpisode(nextepisode);
            completed = true;
          }
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

    if(show.episodes[episodeno + 1] != null) {
      nextepisode = episodeno + 1;
    }
    if(show.episodes[episodeno - 1] != null) {
      previousepisode = episodeno - 1;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.stop();
    super.dispose();
  }

  void UpdateVideoIdStats() async {
    lastplayedshowidsHome.removeWhere((item) => item == show.showid.toString());
    lastplayedshowidsHome.insert(0, show.showid.toString());

    double now = new DateTime.now().millisecondsSinceEpoch/1000;
    int nowint = now.toInt();
    String showidstr = show.showid.toString();
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
          "val": episodeno
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

  Future<void> ShowSnackBarMessage(String message, int duration) async {
    var snackBar = SnackBar(content: Text(message), duration: Duration(milliseconds: duration));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> ChangeEpisode(int episodeno) async {
    if(episodeno != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  PlayScreen(
                    show: show,
                    episodeno: episodeno,
                  )
          )
      );
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
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      ListScreen(
                        show: show,
                        channel: channel,
                        refresh: false,
                        lastplayedepisodeLocal: episodeno,
                      )
              )
          );
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Play Video'),
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
                    Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget> [
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              onPressed: () {
                                if(previousepisode != null) {
                                  ChangeEpisode(previousepisode);
                                } else {
                                  ShowSnackBarMessage('This is the first available Episode', 3000);
                                }
                              },
                              color: Colors.white,
                            ),
                            YoutubeValueBuilder(
                              builder: (context, value) {
                              return IconButton(
                              icon: Icon(
                                value.playerState == PlayerState.playing
                                ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: value.isReady
                              ? () {
                              value.playerState == PlayerState.playing
                              ? context.ytController.pause()
                                  : context.ytController.play();
                              }
                                  : null,
                              );
                              },
                            ),
                            ValueListenableBuilder<bool>(
                            valueListenable: _isMuted,
                            builder: (context, isMuted, _) {
                              return IconButton(
                              icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white, ),
                              onPressed: () {
                                _isMuted.value = !isMuted;
                                isMuted
                                ? context.ytController.unMute()
                                    : context.ytController.mute();
                                },
                              );
                            },
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next, color: Colors.white,),
                              onPressed: () {
                                if(nextepisode != null) {
                                  ChangeEpisode(nextepisode);
                                } else {
                                  ShowSnackBarMessage('This is the first available Episode', 3000);
                                }
                              },
                              color: Colors.white,
                            ),
                          ]
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
                            launchUrl = show.episodes[episodeno].episodeUrl + '&t=' + _controller.value.position.inSeconds.toString();
                            _launchYoutubeVideo(launchUrl);
                          },
                        ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: (show.episodes[episodeno]?.episodeThumbnail ?? "") == "" ? show.posterUrl : show.episodes[episodeno].episodeThumbnail,
                        width: $defaultWidth,
                      ),
                      title: Text(
                        'Episode ' + show.episodes[episodeno].episodeno.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                      ),
                      subtitle: Text(
                        show.episodes[episodeno].episodetitle,
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