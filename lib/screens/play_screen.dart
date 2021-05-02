import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:async';
import 'dart:developer';
import 'package:android_intent/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:daikhopk/constants.dart';

import 'list_screen.dart';

String videoId = '';

class PlayScreen extends StatefulWidget {
  final Show show;
  final Channel channel;
  final int seasonno;
  final int episodeno;
  PlayScreen({required final this.show, required final this.channel, required final this.seasonno, required final this.episodeno});

  @override
  _PlayScreenState createState() => _PlayScreenState(
    show: show,
    channel: channel,
    seasonno: seasonno,
    episodeno: episodeno,
  );
}

class _PlayScreenState extends State<PlayScreen> {
  final Show show;
  final Channel channel;
  final int seasonno;
  final int episodeno;
  late YoutubePlayerController _controller;

  _PlayScreenState({required final this.show, required this.channel, required final this.seasonno, required final this.episodeno});

  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  bool played = false;
  int pos1 = 0;
  int pos2 = 0;
  int timeleft = 0;
  int nextepisode = 0;
  int previousepisode = 0;
  bool completed = false;

  @override
  void initState() {
    super.initState();

    print('PlayVideo InitState');

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if(show.seasons[seasonno]!.episodes[episodeno]!.episodeVideoId == null)
      videoId = YoutubePlayerController.convertUrlToId(show.seasons[seasonno]!.episodes[episodeno]!.episodeUrl)!;
    else
      videoId = show.seasons[seasonno]!.episodes[episodeno]!.episodeVideoId;

    //print('PlayVideo ControllerInit');

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: false,
        enableJavaScript: true,
        desktopMode: !isWeb,
        autoPlay: true,
        playsInline: true,
        startAt: Duration(seconds: 0)
      ),
    )..listen((value) {
      if (value.isReady && !value.hasPlayed) {
        if(!played) {
          _controller.hideTopMenu();
          _controller.hidePauseOverlay();
          if(show.embed == 1) {
            _controller.play();
          } else {
            if (show.embed == 2) {
              _launchYoutubeVideo(show.seasons[seasonno]!.episodes[episodeno]!.episodeUrl);
            } else {
              if (Platform.isAndroid) {
                AndroidIntent intent = AndroidIntent(
                    action: 'action_view',
                    data: show.seasons[seasonno]!.episodes[episodeno]!.episodeUrl,
                    arguments: {'force_fullscreen': true}
                );
                intent.launch();
              } else {
                _launchYoutubeVideo(show.seasons[seasonno]!.episodes[episodeno]!.episodeUrl);
              }
            }
          }
          played = true;
        }
        if(_controller.value.error == YoutubeError.sameAsNotEmbeddable) {
          _controller.stop();
          _controller.reset();
          if(Platform.isAndroid) {
            AndroidIntent intent = AndroidIntent(
                action: 'action_view',
                data: show.seasons[seasonno]!.episodes[episodeno]!.episodeUrl,
                arguments: {'force_fullscreen': true}
            );
            intent.launch();
          } else {
            _launchYoutubeVideo(show.seasons[seasonno]!.episodes[episodeno]!.episodeUrl);
          }
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
      log('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      log('Exited Fullscreen');
    };

    //print('PlayVideo UpdateVideoIdStats');
    UpdateVideoIdStats();

    if(show.seasons[seasonno]!.episodes[episodeno + 1] != null) {
      nextepisode = episodeno + 1;
    }
    if(show.seasons[seasonno]!.episodes[episodeno - 1] != null) {
      previousepisode = episodeno - 1;
    }

    print('PlayVideo InitDone');
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void UpdateVideoIdStats() async {
    if(lastplayedshowidsHome.length > 0) {
      lastplayedshowidsHome.removeWhere((item) =>
      item == show.showid.toString());
    }

    lastplayedshowidsHome.insert(0, show.showid.toString());
    lastplayedshows.clear();
    lastplayedshowidsHome.forEach((element) {
      lastplayedshows.putIfAbsent(
          showsHome.shows[int.parse(element)]!.showid, () => showsHome.shows[int.parse(element)]!);
    });
    
    DateTime currTime = DateTime.now();
    String formattedDatetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(currTime);
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
          "sid": showidstr + '_' + seasonno.toString() + '_' + episodeno.toString(),
          "stat": "vid_lastplayed",
          "val": formattedDatetime
        },
        {
          "sid": showidstr,
          "stat": "show_playcounts",
          "val": "inc"
        },
        {
          "sid": showidstr,
          "stat": "show_lastplayed",
          "val": formattedDatetime
        },
        {
          "sid": showidstr,
          "stat": "show_lastplayedepi",
          "val": seasonno.toString() + '_' + episodeno.toString()
        }
      ]
    };
    postUrl($serviceURLupdatestats, Json);

    Json = {
      "uid": userlocal['uid'],
      "stats": [
        {
          "stat": "vid_lastplaytime",
          "sid": videoId
        }
      ]
    };

    String response = await postUrl($serviceURLgetstats, Json);
    var jsonresult = jsonDecode(response);
    int playtime = jsonresult[0]['vid_lastplaytime'] ?? 0;
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
                    channel: channel,
                    seasonno: seasonno,
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
                        lastplayedseasonLocal: seasonno,
                        lastplayedepisodeLocal: episodeno,
                        backroute: 0,
                      )
              )
          );
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
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
                if (isWeb && constraints.maxWidth > 850) {
                  return Column(
                    children: [
                      Expanded(child: player)
                    ]
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
                                  ShowSnackBarMessage('This is the last available Episode', 3000);
                                }
                              },
                              color: Colors.white,
                            ),
                          ]
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          width: deviceSize.width,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey, width: 2),
                              ),
                              color: Colors.black38,
                            ),
                            child: OutlineButton(
                              highlightColor: Colors.redAccent,
                              splashColor: Colors.grey,
                              onPressed: () {
                                String launchUrl;
                                launchUrl = show.seasons[seasonno]!.episodes[episodeno]!.episodeUrl + '&t=' + _controller.value.position.inSeconds.toString();
                                _launchYoutubeVideo(launchUrl);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey, width: 3),
                              ),
                              highlightElevation: 0,
                              // borderSide: BorderSide(color: Colors.blueGrey, width: 3),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Open Video in',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20.0),
                                    Image(
                                      image: AssetImage("assets/images/Youtube-logo.png"),
                                      height: 25.0,
                                    ),
                                    SizedBox(width: 20.0),
                                    Image(
                                      image: AssetImage("assets/images/cast-logo-white.png"),
                                      height: 20.0,
                                      width: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: (show.seasons[seasonno]!.episodes[episodeno]?.episodeThumbnail ?? "") == "" ? show.posterUrl : show.seasons[seasonno]!.episodes[episodeno]!.episodeThumbnail,
                        width: deviceSize.width/3,
                        fit: BoxFit.fitWidth,
                      ),
                      title: Text(
                        'Episode ' + show.seasons[seasonno]!.episodes[episodeno]!.episodeno.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                      ),
                      subtitle: Text(
                        show.seasons[seasonno]!.episodes[episodeno]!.episodetitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color(0xffaaaaaa),
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