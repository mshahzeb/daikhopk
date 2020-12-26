import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/constants.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Map<int, Show> shows;
  CustomSliverAppBar({@required this.shows});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400.0,
      floating: false,
      pinned: false,
      snap: false,
      backgroundColor: Color(0xff0f0f0f),
      leading: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black
        ),
        child: Image.asset(
          $logopath,
          width: 48,
          height: 48,
        ),
      ),
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xff0f0f0f),
        ),
        child: FlexibleSpaceBar(
          centerTitle: false,
          background: CachedNetworkImage(
            imageUrl: shows[shows.keys.first].posterUrl,
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
                shows[shows.keys.first].showname + ' by ' + shows[shows.keys.first].channel,
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
                    color: Colors.white10,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0),
                        side: BorderSide(color: Colors.white)),
                    child: Row(

                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app_sharp,
                          color: Colors.white,
                          size: 28,
                        ),
                        Text(
                          "Open",
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
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => ListScreen(
                            showid: shows[shows.keys.first].showid,
                            showname: shows[shows.keys.first].showname,
                            posterUrl: shows[shows.keys.first].posterUrl,
                            trailerUrl: shows[shows.keys.first].trailerUrl,
                            trailerVideoId: shows[shows.keys.first].trailerVideoId,
                            embed: shows[shows.keys.first].embed,
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
