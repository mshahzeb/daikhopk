import 'dart:io' show Platform;
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/livechannel.dart';
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

String videoId;
YoutubePlayerController _controller;

class PlayScreenLive extends StatefulWidget {
  final Show show;
  final LiveChannel channel;
  PlayScreenLive({@required final this.show, @required final this.channel});

  @override
  _PlayScreenLiveState createState() => _PlayScreenLiveState(
    show: show,
    channel: channel,
  );
}

class _PlayScreenLiveState extends State<PlayScreenLive> {
  final Show show;
  final LiveChannel channel;

  _PlayScreenLiveState({@required final this.show, @required this.channel});

  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  bool played = false;
  bool completed = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    videoId = channel.videoId;

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
        //startAt: Duration(seconds: 0)
      ),
    )..listen((value) {
      if (value.isReady && !value.hasPlayed) {
        if(!played) {
          _controller.play();
          played = true;
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
    _controller.stop();
    super.dispose();
  }

  void UpdateVideoIdStats() async {
    if(lastplayedshowidsHome.length > 0) {
      lastplayedshowidsHome.removeWhere((item) =>
      item == show.showid.toString());
    }

    lastplayedshowidsHome.insert(0, show.showid.toString());
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
          "sid": channel.channel,
          "stat": "show_lastplayedlivech",
          "val": formattedDatetime
        }
      ]
    };
    postUrl($serviceURLupdatestats, Json);
  }

  Future<void> ShowSnackBarMessage(String message, int duration) async {
    var snackBar = SnackBar(content: Text(message), duration: Duration(milliseconds: duration));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: WillPopScope(
        onWillPop: ()async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: const Text('Play Live Channel'),
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
                                String launchUrl = 'https://www.youtube.com/watch?v=' + channel.videoId;
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
                        imageUrl: channel.logoUrl,
                        width: $defaultWidth,
                      ),
                      title: Text(
                        channel.channel,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                      ),
                      subtitle: Text(
                        'Live',
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