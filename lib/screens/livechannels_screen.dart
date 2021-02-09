import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/livechannel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:daikhopk/screens/play_screen_live.dart';
import 'package:daikhopk/screens/search_screen.dart';
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

class LiveChannelScreen extends StatefulWidget {
  Map<String, LiveChannel> channelsPassed;
  String searchHint;

  LiveChannelScreen({@required this.channelsPassed, this.searchHint});

  @override
  _LiveChannelScreenState createState() => _LiveChannelScreenState(
    channelsPassed: channelsPassed,
    searchHint: searchHint,
  );
}

class _LiveChannelScreenState extends State<LiveChannelScreen> {
  Map<String, LiveChannel> channelsPassed;
  String searchHint;

  _LiveChannelScreenState({@required this.channelsPassed, this.searchHint});
  List<LiveChannel> channelsList = List();

  final SearchBarController<LiveChannel> _searchBarController = SearchBarController();
  Map<int, Show> filteredshows = Map();
  bool isReplay = false;
  int releasesort = 0;
  int ratingssort = 0;
  int viewssort = 0;

  @override
  void initState() {
    super.initState();
    channelsPassed.forEach((key, value) {
      channelsList.add(channelsPassed[key]);
    });
    _searchBarController.replayLastSearch();
  }

  Future<List<LiveChannel>> search(String search) async {
    if(search == "") {
      return channelsList;
    }
    if (search == "empty") return [];
    if (search == "error") throw Error();

    search = search.toLowerCase();
    List<LiveChannel> channels = List();
    final bestMatch = search.bestMatch(channelsPassed.keys.toList());
    if(bestMatch != null && bestMatch.bestMatch != null && bestMatch.bestMatch.rating > 0.0) {
      bestMatch.ratings.sort((a, b) => b.rating.compareTo(a.rating));
      bestMatch.ratings.forEach((element) {
        if(element.rating > 0.0) {
          channels.add(channelsPassed[channelsPassed[element.target]]);
        }
      });
    }
    channelsPassed.forEach((key, value) {
      String temp = channelsPassed[key].channel;
      if(temp.toLowerCase().contains(search) & !channels.contains(channelsPassed[key])) {
        channels.add(channelsPassed[key]);
      }
    });

    return channels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SearchBar<LiveChannel>(
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
                            'Name',
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
                            channelsList.sort((a, b) => b.channel.compareTo(a.channel));
                          });
                          _searchBarController.sortList((LiveChannel a, LiveChannel b) {
                            return b.channel.compareTo(a.channel);
                          });
                        } else {
                          releasesort = 0;
                          setState(() {
                            channelsList.sort((a, b) => a.channel.compareTo(b.channel));
                          });
                          _searchBarController.sortList((LiveChannel a, LiveChannel b) {
                            return a.channel.compareTo(b.channel);
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
                          //  showsList.sort((a, b) => b.likeCount.compareTo(a.likeCount));
                          });
                          //_searchBarController.sortList((Show a, Show b) {
                          //  return b.likeCount.compareTo(a.likeCount);
                          //});
                        } else {
                          ratingssort = 0;
                          setState(() {
                          //  showsList.sort((a, b) => a.likeCount.compareTo(b.likeCount));
                          });
                          //_searchBarController.sortList((Show a, Show b) {
                          //  return a.likeCount.compareTo(b.likeCount);
                          //});
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
                            //showsList.sort((a, b) => b.viewCount.compareTo(a.viewCount));
                          });
                          //_searchBarController.sortList((Show a, Show b) {
                          //  return b.viewCount.compareTo(a.viewCount);
                          //});
                        } else {
                          viewssort = 0;
                          setState(() {
                            //showsList.sort((a, b) => a.viewCount.compareTo(b.viewCount));
                          });
                          //_searchBarController.sortList((Show a, Show b) {
                          //  return a.viewCount.compareTo(b.viewCount);
                          //});
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
            cancellationWidget: Text(
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
            hintText: searchHint,
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
                itemCount: channelsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MyFadeRoute(builder: (context) => PlayScreenLive(
                            channel: channelsList[index],
                          ))
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: channelsList[index].logoUrl,
                                height: $defaultHeight,
                                width: $defaultWidth,
                                fit: BoxFit.contain,
                              ),
                            ]
                        ),
                        SizedBox(height: 5.0,),
                        SizedBox(
                          height: 30,
                          width: $defaultWidth,
                          child: Text(
                            channelsList[index].channel,
                            textAlign: TextAlign.center,
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
            onItemFound: (LiveChannel channel, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(
                      MyFadeRoute(builder: (context) => PlayScreenLive(
                        channel: channel,
                      ))
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    CachedNetworkImage(
                      imageUrl: channel.logoUrl,
                      width: 100,
                      height: 125,
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          channel.channel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          'Live',
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
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "Channels",),
    );
  }
}