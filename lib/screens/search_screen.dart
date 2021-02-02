import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'list_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  _SearchScreenState();
  Map<String, int> showssearch = Map();
  List<Show> showsList = List();

  final SearchBarController<Show> _searchBarController = SearchBarController();
  bool isReplay = false;
  int releasesort = 0;
  int ratingssort = 0;
  int viewssort = 0;

  @override
  void initState() {
    super.initState();
    showsHome.shows.forEach((key, value) {
      showsList.add(showsHome.shows[key]);
    });
    showsList.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    showsHome.shows.forEach((key, value) {
      showssearch.putIfAbsent(showsHome.shows[key].showname, () => showsHome.shows[key].showid);
    });

    _searchBarController.replayLastSearch();
  }

  Future<List<Show>> search(String search) async {
    if(search == "") {
      return showsList;
    }
    if (search == "empty") return [];
    if (search == "error") throw Error();

    search = search.toLowerCase();
    List<Show> shows = List();
    final bestMatch = search.bestMatch(showssearch.keys.toList());
    if(bestMatch != null && bestMatch.bestMatch != null && bestMatch.bestMatch.rating > 0.0) {
      bestMatch.ratings.sort((a, b) => b.rating.compareTo(a.rating));
      bestMatch.ratings.forEach((element) {
        if(element.rating > 0.0) {
          shows.add(showsHome.shows[showssearch[element.target]]);
        }
      });
    }
    showsHome.shows.forEach((key, value) {
      String temp = showsHome.shows[key].showname + ' ' + showsHome.shows[key].channel + showsHome.shows[key].releaseDatetime.year.toString();
      if(temp.toLowerCase().contains(search) & !shows.contains(showsHome.shows[key])) {
        shows.add(showsHome.shows[key]);
      }
    });

    return shows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SearchBar<Show>(
            onSearch: search,
            searchBarStyle: SearchBarStyle(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(5),
            ),
            searchBarController: _searchBarController,
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
            header: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.black,
                      child: Row(
                        children: <Widget> [
                          Icon(
                            LineAwesomeIcons.sort,
                            color: Colors.white,
                            size: 25,
                          ),
                          Text(
                            'Released',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]
                      ),
                      onPressed: () {
                        if(releasesort == 0) {
                          releasesort = 1;
                          setState(() {
                            showsList.sort((a, b) => b.releaseDatetime.compareTo(a.releaseDatetime));
                          });
                          _searchBarController.sortList((Show a, Show b) {
                            return b.releaseDatetime.compareTo(a.releaseDatetime);
                          });
                        } else {
                          releasesort = 0;
                          setState(() {
                            showsList.sort((a, b) => a.releaseDatetime.compareTo(b.releaseDatetime));
                          });
                          _searchBarController.sortList((Show a, Show b) {
                            return a.releaseDatetime.compareTo(b.releaseDatetime);
                          });
                        }
                      },
                    ),
                    Spacer(),
                    RaisedButton(
                      color: Colors.black,
                      child: Row(
                          children: <Widget> [
                            Icon(
                              LineAwesomeIcons.sort,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              'Rating',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]
                      ),
                      onPressed: () {
                        if(ratingssort == 0) {
                          ratingssort = 1;
                          setState(() {
                            showsList.sort((a, b) => b.likeCount.compareTo(a.likeCount));
                          });
                          _searchBarController.sortList((Show a, Show b) {
                            return b.likeCount.compareTo(a.likeCount);
                          });
                        } else {
                          ratingssort = 0;
                          setState(() {
                            showsList.sort((a, b) => a.likeCount.compareTo(b.likeCount));
                          });
                          _searchBarController.sortList((Show a, Show b) {
                            return a.likeCount.compareTo(b.likeCount);
                          });
                        }
                      },
                    ),
                    Spacer(),
                    RaisedButton(
                      color: Colors.black,
                      child: Row(
                          children: <Widget> [
                            Icon(
                              LineAwesomeIcons.sort,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              'Views',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]
                      ),
                      onPressed: () {
                        if(viewssort == 0) {
                          viewssort = 1;
                          setState(() {
                            showsList.sort((a, b) => b.viewCount.compareTo(a.viewCount));
                          });
                          _searchBarController.sortList((Show a, Show b) {
                            return b.viewCount.compareTo(a.viewCount);
                          });
                        } else {
                          viewssort = 0;
                          setState(() {
                            showsList.sort((a, b) => a.viewCount.compareTo(b.viewCount));
                          });
                          _searchBarController.sortList((Show a, Show b) {
                            return a.viewCount.compareTo(b.viewCount);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
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
            hintText: "Show, Channel or Year Released",
            hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 1,
            icon: Icon(LineAwesomeIcons.search),
            indexedScaledTileBuilder: (int index) => ScaledTile.fit(1),
            placeHolder: Container(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                itemCount: showsList.length,
                itemBuilder: (BuildContext context, int index) {
                  int key = showsList.length;
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MyFadeRoute(builder: (context) =>
                            ListScreen(
                              show: showsList[index],
                              channel: showsHome.channels[showsList[index].channel],
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
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: showsList[index].posterUrl,
                                height: $defaultHeight,
                                width: $defaultWidth,
                                fit: BoxFit.fitHeight,
                              ),
                              CachedNetworkImage(
                                imageUrl: showsHome.channels[showsList[index]
                                    .channel].logoUrl,
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
                            showsList[index].showname,
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
                  );
                },
                //staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 2 : 1),
                //staggeredTileBuilder: (int index) => new StaggeredTile.count(2, 1),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              )
            ),
            onItemFound: (Show show, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(
                    MyFadeRoute(builder: (context) => ListScreen(
                        show: show,
                        channel: showsHome.channels[show.channel],
                        refresh: true
                    )
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    CachedNetworkImage(
                      imageUrl: show.posterUrl,
                      width: 100,
                      height: 125,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          show.showname,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          numdisplay(show.viewCount).toString() + ' ' + 'Views'
                          '\n' + numdisplay(show.likeCount).toString() + ' ' + 'Likes'
                          '\n' + show.releaseDatetime.year.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            height: 1.5,
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