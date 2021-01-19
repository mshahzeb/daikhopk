import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/screens/showslist_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'list_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  _SearchScreenState();

  Future<List<int>> search(String search) async {
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<int> showids = [];
    showsHome.shows.forEach((key, value) {
      if (showsHome.shows[key].showname.toLowerCase().contains(search.toLowerCase())) {
        showids.add(showsHome.shows[key].showid);
      }
    });

    return showids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SearchBar<int>(
            onSearch: search,
            searchBarStyle: SearchBarStyle(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(5),
            ),
            minimumChars: 1,
            debounceDuration: Duration(milliseconds: 500),
            onError: (error) {
              return Center(
                child: Text(
                  'Error occurred : $error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            emptyWidget: Center(
              child: Text(
                'Nothing Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            cancellationText: Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            loader: Center(
              child: Text(
                'Searching',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            hintText: "Type in a Show Name",
            hintStyle: TextStyle(
                color: Colors.black,
              ),
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 1,
            //icon: Icon(Icons.youtube_searched_for),
            indexedScaledTileBuilder: (int index) => ScaledTile.fit(1),
            placeHolder: Container(
              child: Column(
                children: [
                  SizedBox(
                    width: deviceSize.width,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 2),
                        ),
                        color: Colors.black38,
                      ),
                      child: OutlineButton(
                        highlightColor: Colors.redAccent,
                        splashColor: Colors.grey,
                        onPressed: () {
                          Navigator.of(context).push(
                            MyFadeRoute(builder: (context) => ShowsList(
                              title: 'All Shows',
                              type: 'all',
                              filter: '',
                            )
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 3),
                        ),
                        highlightElevation: 0,
                        // borderSide: BorderSide(color: Colors.blueGrey, width: 3),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            'All Shows (' + showsHome.shows.length.toString() + ')',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox( height:10 ),
                  SizedBox(
                    width: deviceSize.width,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 2),
                        ),
                        color: Colors.black38,
                      ),
                      child: OutlineButton(
                        highlightColor: Colors.redAccent,
                        splashColor: Colors.grey,
                        onPressed: () {
                          String launchUrl;
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 3),
                        ),
                        highlightElevation: 0,
                        // borderSide: BorderSide(color: Colors.blueGrey, width: 3),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            'Find by Channels (' + showsHome.channels.length.toString() + ')',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox( height:10 ),
                  SizedBox(
                    width: deviceSize.width,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 2),
                        ),
                        color: Colors.black38,
                      ),
                      child: OutlineButton(
                        highlightColor: Colors.redAccent,
                        splashColor: Colors.grey,
                        onPressed: () {
                          String launchUrl;
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 3),
                        ),
                        highlightElevation: 0,
                        // borderSide: BorderSide(color: Colors.blueGrey, width: 3),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            'Find by Release Year',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            onItemFound: (int showid, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(
                    MyFadeRoute(builder: (context) => ListScreen(
                        show: showsHome.shows[showid],
                        channel: showsHome.channels[showsHome.shows[showid].channel],
                        refresh: true
                    )
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    CachedNetworkImage(
                      imageUrl: showsHome.shows[showid].posterUrl,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          showsHome.shows[showid].showname,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          '\n' + showsHome.shows[showid].releaseYear.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ]
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "Explore",),
    );
  }
}