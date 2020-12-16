import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:daikhopk/widgets/play_pause_button_bar.dart';
import 'package:daikhopk/models/episode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/constants.dart';

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

  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    String videoId;

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
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: kIsWeb,
        autoPlay: true,
        playsInline: true,
        startAt: const Duration(minutes: 0, seconds: 0),
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
      // Passing controller to widgets below.
      controller: _controller,
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