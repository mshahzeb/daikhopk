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
              refresh: true,
              backroute: 0,
            )
        ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget> [
                CachedNetworkImage(
                  imageUrl: show.posterUrl,
                  height: $defaultHeight,
                  width: $defaultWidth,
                  fit: BoxFit.fitWidth,
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
              height: 50,
              width: $defaultWidth,
              child: Text(
                show.showname,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}
