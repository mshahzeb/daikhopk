import 'package:daikhopk/models/show.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/widgets/horizontal_list_item.dart';

import 'horizontal_list_item.dart';

class HorizontalList extends StatelessWidget {
  final List<Show> shows;
  HorizontalList({this.shows});

  final List<Widget> _horizontalListItem = List<Widget>();

  List<Widget> buildTile() {
    // for (var i = 0; i < posterUrls.length; i++) {
    for (var i = 0; i < shows.length; i++) {
      _horizontalListItem.add(SizedBox(
        width: 10,
      ));
      _horizontalListItem.add(HorizontalListItem(
          showid: shows[i].showid,
          showname: shows[i].showname,
          posterUrl: shows[i].posterUrl,
          trailerUrl: shows[i].trailerUrl,
          embed: shows[i].embed,
      ));
    }
    return _horizontalListItem;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // This next line does the trick.
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, position) {
          return Row(children: buildTile());
        });
  }
}
