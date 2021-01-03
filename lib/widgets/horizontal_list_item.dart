import 'package:daikhopk/models/channel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/constants.dart';

class HorizontalListItem extends StatelessWidget {
  final Show show;
  final Channel channel;

  HorizontalListItem({@required final this.show, final this.channel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MyFadeRoute(builder: (context) => ListScreen(
              show: show,
              channel: channel,
            )
        ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
          alignment: Alignment.topRight,
          children: <Widget> [
            CachedNetworkImage(
              imageUrl: show.posterUrl,
              height: $defaultHeight,
              width: $defaultWidth,
              fit: BoxFit.fitHeight,
            ),
            CachedNetworkImage(
                imageUrl: channel.logoUrl,
                height: 25,
                width: 25,
                fit: BoxFit.fitHeight,
            ),
            ]
          ),
          SizedBox(
            height: 30,
            width: $defaultWidth,
            child: Text(
              show.showname,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      )
    );
  }
}
