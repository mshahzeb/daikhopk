import 'package:daikhopk/constants.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/widgets/horizontal_list_item.dart';
<<<<<<< HEAD
=======
import 'package:list_wheel_scroll_view_x/list_wheel_scroll_view_x.dart';

>>>>>>> c88ee12dc24cf7481cf99138cba061c87dc9f8c9
import 'horizontal_list_item.dart';

class HorizontalList extends StatefulWidget {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;
  final List<String> filtershowids;

  HorizontalList({@required final this.shows, final this.channels, final this.filtershowids});

<<<<<<< HEAD
  @override
  _HorizontalListState createState() => _HorizontalListState(
    shows: shows,
    channels: channels,
    filtershowids: filtershowids,
  );
}

class _HorizontalListState extends State<HorizontalList> {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;
  final List<String> filtershowids;

  _HorizontalListState({@required final this.shows, final this.channels, final this.filtershowids});

=======
>>>>>>> c88ee12dc24cf7481cf99138cba061c87dc9f8c9
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
          Navigator.of(context).push(
              MyFadeRoute(builder: (context) => SearchScreen(
                showsPassed: shows,
                searchHint: 'Show, Channel or Year Released',
              ))
          );
        },
      ),
    ));

    return _horizontalListItem;
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollViewX(
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
