import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/constants.dart';

class CustomSliverAppBar extends StatelessWidget {
  final List<Show> shows;
  CustomSliverAppBar({@required this.shows});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400.0,
      floating: false,
      pinned: false,
      snap: false,
      backgroundColor: Color(0xff0f0f0f),
      leading:
        Image.asset(
          $logopath,
          width: 48,
          height: 48,
        ),
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xff0f0f0f),
        ),
        child: FlexibleSpaceBar(
          centerTitle: false,
          background: CachedNetworkImage(
            imageUrl: shows[0].posterUrl,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      bottom: PreferredSize(
        // preferredSize: const Size.fromHeight(0.0),
        preferredSize: Size(0, kToolbarHeight),
        child: Transform.translate(
          offset: const Offset(0, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Guerra ' +
                    String.fromCharCode($middot) +
                    ' Drama ' +
                    String.fromCharCode($middot) +
                    ' Ação ' +
                    String.fromCharCode($middot) +
                    ' Thriller ',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0),
                        side: BorderSide(color: Colors.white)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.play_arrow,
                          color: Colors.black87,
                          size: 28,
                        ),
                        Text(
                          "Play",
                          style: TextStyle(
                            fontFamily: 'Confortaa',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => ListScreen(
                            showid: shows[0].showid,
                            showname: shows[0].showname,
                            posterUrl: shows[0].posterUrl,
                            trailerUrl: shows[0].trailerUrl,
                            trailerVideoId: shows[0].trailerVideoId,
                            embed: shows[0].embed,
                          )
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        SizedBox(
          width: 100,
        ),
      ],
    );
  }
}
