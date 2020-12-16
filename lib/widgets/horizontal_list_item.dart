// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/constants.dart';

class HorizontalListItem extends StatelessWidget {
  final int showid;
  final String showname;
  final String posterUrl;
  final String trailerUrl;
  final String trailerVideoId;
  final int embed;

  HorizontalListItem({@required final this.showid, this.showname, final this.posterUrl, final this.trailerUrl, final this.trailerVideoId, final this.embed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
            MaterialPageRoute(builder: (context) => ListScreen(
              showid: showid,
              showname: showname,
              posterUrl: posterUrl,
              trailerUrl: trailerUrl,
              trailerVideoId: trailerVideoId,
              embed: embed,
            )
        ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: posterUrl,
            width: $defaultWidth,
          ),
        ],
      )
    );
  }
}
