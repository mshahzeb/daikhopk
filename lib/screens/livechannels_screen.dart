import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/livechannel.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/play_screen_live.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class LiveChannelScreen extends StatefulWidget {
  Map<String, LiveChannel> channelsPassed;
  String searchHint;

  LiveChannelScreen({required this.channelsPassed, required this.searchHint});

  @override
  _LiveChannelScreenState createState() => _LiveChannelScreenState(
    channelsPassed: channelsPassed,
    searchHint: searchHint,
  );
}

class _LiveChannelScreenState extends State<LiveChannelScreen> {
  Map<String, LiveChannel> channelsPassed;
  String searchHint;

  _LiveChannelScreenState({required this.channelsPassed, required this.searchHint});
  List<LiveChannel> channelsList = [];
  List<LiveChannel> channelsList_Init = [];

  Map<int, Show> filteredshows = Map();
  bool loading = false;
  int namesort = 0;

  @override
  void initState() {
    super.initState();
    channelsPassed.forEach((key, value) {
      channelsList.add(channelsPassed[key]!);
    });
    channelsList_Init = channelsList;
  }

  void search(String search) async {
    setState(() {
      loading = true;
    });
    if(search != "") {
      search = search.toLowerCase();
      List<LiveChannel> channels = [];
      final bestMatch = search.bestMatch(channelsPassed.keys.toList());
      if(bestMatch.bestMatch.rating! > 0.0) {
        bestMatch.ratings.sort((a, b) => b.rating!.compareTo(a.rating!));
        bestMatch.ratings.forEach((element) {
          if(element.rating! > 0.0) {
            channels.add(channelsPassed[channelsPassed[element.target]]!);
          }
        });
      }
      channelsPassed.forEach((key, value) {
        String temp = channelsPassed[key]!.channel;
        if(temp.toLowerCase().contains(search) & !channels.contains(channelsPassed[key])) {
          channels.add(channelsPassed[key]!);
        }
      });

      channelsList = channels;
    } else {
      channelsList = channelsList_Init;
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
                      itemCount: channelsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MyFadeRoute(builder: (context) => PlayScreenLive(
                                  channel: channelsList[index],
                                  show: Show(),
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
                            for (var i=0; i<(channelsList.length < 50 ? channelsList.length : 50); i++)
                              Container(
                                //height: 150,
                                padding: EdgeInsets.all(5.00),
                                color: Colors.black,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MyFadeRoute(builder: (context) => PlayScreenLive(
                                          channel: channelsList[i],
                                          show: Show(),
                                        ))
                                    );
                                  },
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget> [
                                        CachedNetworkImage(
                                          imageUrl: channelsList[i].logoUrl,
                                          width: 100,
                                          height: 125,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.topCenter,
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              channelsList[i].channel,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
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
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "Channels",),
    );
  }
}