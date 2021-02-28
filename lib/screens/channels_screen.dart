import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/show.dart';
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

class ChannelScreen extends StatefulWidget {
  Map<String, Channel> channelsPassed;
  String searchHint;

  ChannelScreen({@required this.channelsPassed, this.searchHint});

  @override
  _ChannelScreenState createState() => _ChannelScreenState(
    channelsPassed: channelsPassed,
    searchHint: searchHint,
  );
}

class _ChannelScreenState extends State<ChannelScreen> {
  Map<String, Channel> channelsPassed;
  String searchHint;

  _ChannelScreenState({@required this.channelsPassed, this.searchHint});
  List<Channel> channelsList = [];

  final SearchBarController<Channel> _searchBarController = SearchBarController();
  Map<int, Show> filteredshows = Map();
  bool isReplay = false;
  int namesort = 0;

  @override
  void initState() {
    super.initState();
    channelsPassed.forEach((key, value) {
      channelsList.add(channelsPassed[key]);
    });
    _searchBarController.replayLastSearch();
  }

  Future<List<Channel>> search(String search) async {
    if(search == "") {
      return channelsList;
    }
    if (search == "empty") return [];
    if (search == "error") throw Error();

    search = search.toLowerCase();
    List<Channel> channels = [];
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
          child: SearchBar<Channel>(
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
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ]
                      ),
                      onPressed: () {
                        if(namesort == 0) {
                          namesort = 1;
                          setState(() {
                            channelsList.sort((a, b) => b.channel.compareTo(a.channel));
                          });
                          _searchBarController.sortList((Channel a, Channel b) {
                            return b.channel.compareTo(a.channel);
                          });
                        } else {
                          namesort = 0;
                          setState(() {
                            channelsList.sort((a, b) => a.channel.compareTo(b.channel));
                          });
                          _searchBarController.sortList((Channel a, Channel b) {
                            return a.channel.compareTo(b.channel);
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
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            cancellationWidget: Text(
              'Clear',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 1,
            icon: Icon(LineAwesomeIcons.search),
            indexedScaledTileBuilder: (int index) => ScaledTile.fit(1),
            placeHolder: Container(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: (deviceSize.width/($defaultWidth)).floor(),
                itemCount: channelsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      filteredshows.clear();
                      showsHome.shows.forEach((key, value) {
                        if(showsHome.shows[key].channel == channelsList[index].channel) {
                          filteredshows.putIfAbsent(
                              showsHome.shows[key].showid, () => showsHome
                              .shows[key]);
                        }
                      });

                      Navigator.of(context).push(
                          MyFadeRoute(builder: (context) => SearchScreen(
                            showsPassed: filteredshows,
                            searchHint: 'Show or Year Released',
                          ))
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
                                imageUrl: channelsList[index].logoUrl,
                                height: $defaultHeight,
                                width: $defaultWidth,
                                fit: BoxFit.fitHeight,
                              ),
                            ]
                        ),
                        SizedBox(height: 5.0,),
                        SizedBox(
                          height: 30,
                          width: $defaultWidth,
                          child: Text(
                            channelsList[index].channel + ' ' + '(' + channelsList[index].shows.toString() + ')',
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
            onItemFound: (Channel channel, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  filteredshows.clear();
                  showsHome.shows.forEach((key, value) {
                    if(showsHome.shows[key].channel == channel.channel) {
                      filteredshows.putIfAbsent(
                          showsHome.shows[key].showid, () => showsHome
                          .shows[key]);
                    }
                  });

                  Navigator.of(context).push(
                      MyFadeRoute(builder: (context) => SearchScreen(
                        showsPassed: filteredshows,
                        searchHint: 'Show or Year Released',
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
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          channel.channel,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          channel.shows.toString() + ' Shows',
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