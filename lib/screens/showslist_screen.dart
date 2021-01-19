import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'list_screen.dart';

class ShowsList extends StatefulWidget {
  final String title;
  final String type;
  final String filter;

  ShowsList({@required final this.title, final this.type, final this.filter});

  @override
  _ShowsListState createState() => _ShowsListState(
    title: title,
    type: type,
    filter: filter,
  );
}

class _ShowsListState extends State<ShowsList> {
  final  String title;
  String type;
  String filter;

  _ShowsListState({@required final this.title, final this.type, final this.filter});

  List<Show> shows = [];

  @override
  void initState() {
    if(type == 'all') {
      showsHome.shows.forEach((key, value) {
        shows.add(showsHome.shows[key]);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title + ' (' + shows.length.toString() + ')'),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: shows.length,
            itemBuilder: (BuildContext context, int index) => new GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MyFadeRoute(builder: (context) => ListScreen(
                      show: shows[index],
                      channel: showsHome.channels[shows[index].channel],
                      refresh: true,
                      backroute: 1,
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
                        imageUrl: shows[index].posterUrl,
                        height: $defaultHeight,
                        width: $defaultWidth,
                        fit: BoxFit.fitHeight,
                      ),
                      CachedNetworkImage(
                        imageUrl: showsHome.channels[shows[index].channel].logoUrl,
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
                      shows[index].showname,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Comfortaa',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 2 : 1),
            //staggeredTileBuilder: (int index) => new StaggeredTile.count(2, 1),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          )
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "ShowsList",),
    );
  }
}