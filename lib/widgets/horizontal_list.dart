import 'package:daikhopk/constants.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/widgets/horizontal_list_item.dart';
import 'package:list_wheel_scroll_view_x/list_wheel_scroll_view_x.dart';

import 'horizontal_list_item.dart';

class HorizontalList extends StatelessWidget {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;
  final List<String> filtershowids;

  HorizontalList({@required final this.shows, final this.channels, final this.filtershowids});

  final List<Widget> _horizontalListItem = [];

  List<Widget> buildTile() {
    int check = filtershowids?.length ?? 0;
    if (check == 0) {
      int key = 0;
      for(int i=0; i<shows.length; i++) {
        key = shows.keys.elementAt(i);
        _horizontalListItem.add(SizedBox(
          width: 10,
        ));
        _horizontalListItem.add(HorizontalListItem(
          show: shows[key],
          channel: channels[shows[key].channel],
        ));
        if( i == $maxtiles) {
          break;
        }
      }
    } else {
      int key = 0;
      for(int i=0; i<filtershowids.length; i++) {
        key = int.parse(filtershowids[i]);
        _horizontalListItem.add(SizedBox(
          width: 10,
        ));
        _horizontalListItem.add(HorizontalListItem(
          show: shows[key],
          channel: channels[shows[key].channel],
        ));
        if( i == $maxtiles) {
          break;
        }
      }
    }

    _horizontalListItem.add(SizedBox(
      width: 10,
    ));
    _horizontalListItem.add(Center(
      child: TextButton(
        child: Text(
          'MORE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffaaaaaa),
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,

          ),
        ),
        onPressed: () async {

        },
      ),
    ));

    return _horizontalListItem;
  }

  @override
  Widget build(BuildContext context) {
    return  ListWheelScrollViewX(
      scrollDirection: Axis.horizontal,
      itemExtent: 100,
      diameterRatio: 10,
      squeeze: 2,
      magnification: 1.5,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      children: buildTile()
    );
  }
}
