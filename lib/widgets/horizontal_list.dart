import 'package:daikhopk/models/show.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/widgets/horizontal_list_item.dart';

import 'horizontal_list_item.dart';

class HorizontalList extends StatelessWidget {
  final Map<int, Show> shows;
  final String uid;
  final List<String> filtershowids;

  HorizontalList({this.shows, this.uid, this.filtershowids});

  final List<Widget> _horizontalListItem = List<Widget>();

  List<Widget> buildTile() {
    int check = filtershowids?.length ?? 0;
    if (check == 0) {
      shows.forEach((key, value) {
        _horizontalListItem.add(SizedBox(
          width: 10,
        ));
        _horizontalListItem.add(HorizontalListItem(
            showid: shows[key].showid,
            showname: shows[key].showname,
            posterUrl: shows[key].posterUrl,
            trailerUrl: shows[key].trailerUrl,
            embed: shows[key].embed,
            uid: uid
        ));
      });
    } else {
      int key = 0;
      filtershowids.forEach((element) {
        key = int.parse(element);
        _horizontalListItem.add(SizedBox(
          width: 10,
        ));
        _horizontalListItem.add(HorizontalListItem(
            showid: shows[key].showid,
            showname: shows[key].showname,
            posterUrl: shows[key].posterUrl,
            trailerUrl: shows[key].trailerUrl,
            embed: shows[key].embed,
            uid: uid
        ));
      });
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
