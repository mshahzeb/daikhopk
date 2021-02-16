import 'package:daikhopk/constants.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/contactus_screen.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/widgets/horizontal_list_item.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'horizontal_list_item.dart';

class HorizontalList extends StatefulWidget {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;

  HorizontalList({@required final this.shows, final this.channels});

  @override
  _HorizontalListState createState() => _HorizontalListState(
    shows: shows,
    channels: channels,
  );
}

class _HorizontalListState extends State<HorizontalList> {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;

  _HorizontalListState({@required final this.shows, final this.channels});

  Widget _buildListItem(BuildContext context, int index) {
    int key = shows.keys.elementAt(index);
    return HorizontalListItem(
      show: shows[key],
      channel: channels[shows[key].channel],
    );
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
              itemCount: (shows.length < 20 ? shows.length:20) + 1,
              itemBuilder: _buildListItem,
            ),
          ),
        ]
      ),
    );
  }

}
