import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'list_screen.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchScreen extends StatefulWidget {
  Map<int, Show> showsPassed;
  String searchHint;
  SearchScreen({required this.showsPassed, required this.searchHint});

  @override
  _SearchScreenState createState() => _SearchScreenState(
    showsPassed: showsPassed,
    searchHint: searchHint,
  );
}

class _SearchScreenState extends State<SearchScreen> {
  Map<int, Show> showsPassed;
  String searchHint;

  _SearchScreenState({required this.showsPassed, required this.searchHint});

  Map<String, int> showssearch = Map();
  List<Show> showsList = [];
  List<Show> showsList_Init = [];

  bool loading = false;
  int releasesort = 0;
  int ratingssort = 0;
  int viewssort = 0;

  @override
  void initState() {
    super.initState();
    showsPassed.forEach((key, value) {
      showsList.add(showsPassed[key]!);
    });
    showsList.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    showsPassed.forEach((key, value) {
      showssearch.putIfAbsent(showsPassed[key]!.showname, () => showsPassed[key]!.showid);
    });
    showsList.shuffle();
    showsList_Init = showsList;
  }

  void search(String search) async {
    setState(() {
      loading = true;
    });
    if(search != "") {
      search = search.toLowerCase();
      List<Show> shows = [];
      final bestMatch = search.bestMatch(showssearch.keys.toList());
      if (bestMatch.bestMatch.rating! > 0.0) {
        bestMatch.ratings.sort((a, b) => b.rating!.compareTo(a.rating!));
        bestMatch.ratings.forEach((element) {
          if (element.rating! > 0.0) {
            shows.add(showsPassed[showssearch[element.target]]!);
          }
        });
      }
      showsPassed.forEach((key, value) {
        String temp = showsPassed[key]!.showname + ' ' +
            showsPassed[key]!.channel +
            showsPassed[key]!.releaseDatetime.year.toString();
        if (temp.toLowerCase().contains(search) & !shows.contains(
            showsPassed[key])) {
          shows.add(showsPassed[key]!);
        }
      });

      showsList = shows;
    } else {
      showsList = showsList_Init;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            fit: StackFit.loose,
            children: [
              FloatingSearchBar(
                hint: searchHint,
                isScrollControlled: true,
                clearQueryOnClose: true,
                accentColor: Colors.redAccent,
                shadowColor: Colors.black,
                backgroundColor: Colors.white,
                backdropColor: Colors.black,
                iconColor: Colors.black,
                scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                transitionDuration: const Duration(milliseconds: 250),
                transitionCurve: Curves.easeInOut,
                physics: const BouncingScrollPhysics(),
                axisAlignment: 0.0,
                openAxisAlignment: 0.0,
                width: 600,
                debounceDelay: const Duration(milliseconds: 500),
                progress: loading,
                onQueryChanged: (query) {
                  search(query);
                },
                transition: CircularFloatingSearchBarTransition(),
                actions: [
                  FloatingSearchBarAction.searchToClear(
                    showIfClosed: true,
                  ),
                ],
                body: Container(
                  padding: EdgeInsets.only(top: 80.00),
                  child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    crossAxisCount: (deviceSize.width/($defaultWidth)).floor(),
                    itemCount: showsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MyFadeRoute(builder: (context) =>
                                ListScreen(
                                  show: showsList[index],
                                  channel: showsHome.channels[showsList[index].channel]!,
                                  refresh: true,
                                  backroute: 1,
                                  lastplayedseasonLocal: 0,
                                  lastplayedepisodeLocal: 0,
                                )
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 10),
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
                                    imageUrl: showsHome.channels[showsList[index].channel]!.logoUrl,
                                    height: 25,
                                    width: 25,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ]
                            ),
                            SizedBox(
                              height: 50,
                              width: $defaultWidth,
                              child: Text(
                                showsList[index].showname,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
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
                builder: (context, transition) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Colors.white,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i=0; i<(showsList.length < 50 ? showsList.length : 50); i++)
                            Container(
                              //height: 150,
                              padding: EdgeInsets.all(5.00),
                              color: Colors.black,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MyFadeRoute(builder: (context) => ListScreen(
                                      show: showsList[i],
                                      channel: showsHome.channels[showsList[i].channel]!,
                                      refresh: true,
                                      backroute: 1,
                                      lastplayedseasonLocal: 0,
                                      lastplayedepisodeLocal: 0,
                                    )
                                    ),
                                  );
                                },
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget> [
                                      Stack(
                                          alignment: Alignment.topRight,
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              imageUrl: showsList[i].posterUrl,
                                              //height: $defaultHeight,
                                              width: $defaultWidth,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            CachedNetworkImage(
                                              imageUrl: showsHome.channels[showsList[i].channel]!.logoUrl,
                                              height: 25,
                                              width: 25,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ]
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            showsList[i].showname,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          subtitle: Text(
                                            numdisplay(showsList[i].viewCount).toString() + ' ' + 'Views'
                                                '\n' + numdisplay(showsList[i].likeCount).toString() + ' ' + 'Likes'
                                                '\n' + showsList[i].releaseDatetime.year.toString(),
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
                              ),
                            )
                          ]
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "Explore",),
    );
  }
}