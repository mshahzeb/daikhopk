import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/widgets/horizontal_list_item.dart';

import 'horizontal_list_item.dart';

class HorizontalList extends StatelessWidget {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;
  final List<String> filtershowids;

  HorizontalList({@required final this.shows, final this.channels, final this.filtershowids});

  final List<Widget> _horizontalListItem = List<Widget>();

  List<Widget> buildTile() {
    int check = filtershowids?.length ?? 0;
    if (check == 0) {
      shows.forEach((key, value) {
        _horizontalListItem.add(SizedBox(
          width: 10,
        ));
        _horizontalListItem.add(HorizontalListItem(
            show: shows[key],
            channel: channels[shows[key].channel],
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
            show: shows[key],
            channel: channels[shows[key].channel],
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
          return Row(
            children: buildTile()
          );
        });
  }
}
