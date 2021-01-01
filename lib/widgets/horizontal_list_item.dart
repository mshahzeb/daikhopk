import 'package:daikhopk/screens/splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/constants.dart';

class HorizontalListItem extends StatelessWidget {
  final Show show;

  HorizontalListItem({@required final this.show});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ListScreen(
              show: show,
            )
        ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: show.posterUrl,
            height: $defaultHeight,
            width: $defaultWidth,
            fit: BoxFit.fitHeight,
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
