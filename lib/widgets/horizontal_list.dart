import 'package:daikhopk/constants.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/widgets/horizontal_list_item.dart';
import 'horizontal_list_item.dart';

class HorizontalList extends StatefulWidget {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;
  final bool order;

  HorizontalList({@required final this.shows, final this.channels, final this.order});

  @override
  _HorizontalListState createState() => _HorizontalListState(
    shows: shows,
    channels: channels,
    order: order,
  );
}

class _HorizontalListState extends State<HorizontalList> {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;
  final bool order;

  _HorizontalListState({@required final this.shows, final this.channels, final this.order});

  Widget _buildListItem(BuildContext context, int index) {
    if((index < shows.length) && (index < $maxtiles)) {
      int idx;
      if(order) {
        idx = index;
      } else {
        idx = (shows.length - 1) - index;
      }
      final int key = shows.keys.elementAt(idx);
      return HorizontalListItem(
        show: shows[key],
        channel: channels[shows[key].channel],
      );
    } else {
      return TextButton(
        child: Text(
          'More',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            color: Color(0xffaaaaaa),
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
          children: <Widget> [
            Expanded(
              child: ListView.builder(
              // This next line does the trick.
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: (shows.length < $maxtiles ? shows.length:$maxtiles) + 1,
              itemBuilder: _buildListItem,
            ),
          ),
        ]
      ),
    );
  }

}
