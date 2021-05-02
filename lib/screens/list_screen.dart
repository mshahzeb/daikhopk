import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/shows.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/screens/play_screen.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/utils/webservice.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:daikhopk/constants.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  final Show show;
  final Channel channel;
  final bool refresh;
  final int lastplayedseasonLocal;
  final int lastplayedepisodeLocal;
  final int backroute;

  ListScreen({required final this.show, required final this.channel, required final this.refresh, required final this.lastplayedseasonLocal, required final this.lastplayedepisodeLocal, required final this.backroute});

  @override
  _ListScreenState createState() => _ListScreenState(
    show: show,
    channel: channel,
    refresh: refresh,
    lastplayedseasonLocal: lastplayedseasonLocal,
    lastplayedepisodeLocal: lastplayedepisodeLocal,
    backroute: backroute,
  );
}

class _ListScreenState extends State<ListScreen> {
  late final Show show;
  late final Channel channel;
  bool refresh = false;
  int lastplayedseasonLocal = 0;
  int lastplayedepisodeLocal = 0;
  int backroute = 0;

  int seasonno = 1;

  int error = 0;
  int _lastplayedseason = 0;
  int _lastplayedepisode = 0;
  late Future<Show> _dataRequiredForBuild;
  _ListScreenState({required final this.show, required final this.channel, required this.refresh, required final this.lastplayedseasonLocal, required final this.lastplayedepisodeLocal, required final this.backroute});

  @override
  void initState() {
    super.initState();

    _dataRequiredForBuild = fetchData();
    UpdateShowIdStats();
  }

  Future<Show> fetchData() async {
    try {
      _dropdownMenuItems = buildDropDownMenuItems();
      if(refresh) {
        String episodes = await fetchUrlCached(show.showid);
        Map<int, Show> temp = Shows
            .fromJson(jsonDecode(episodes))
            .shows;
        showLocal = temp[temp.keys.first]!;

        Map <String, dynamic> Json = {
          "uid": userlocal['uid'],
          "stats": [
            {
              "stat": "show_lastplayedepi",
              "sid": show.showid.toString()
            }
          ]
        };

        String response = await postUrl($serviceURLgetstats, Json);
        var jsonresult = jsonDecode(response);
        String result = jsonresult[0]['show_lastplayedepi'];
        if((result != null) && result != "-1" && result != "0") {
          _lastplayedseason = int.parse(result.split('_')[0]);
          _lastplayedepisode = int.parse(result.split('_')[1]);
        } else {
          _lastplayedseason = -1;
          _lastplayedepisode = -1;
        }
      } else {
        _lastplayedseason = lastplayedseasonLocal;
        _lastplayedepisode = lastplayedepisodeLocal;
      }

      if(_lastplayedseason > 0) {
        seasonno = _lastplayedseason;
        _selectedItem = _dropdownMenuItems[_lastplayedseason-1].value!;
      } else {
        _selectedItem = _dropdownMenuItems[0].value!;
      }

      return show;

    } catch(e) {
      error = 1;
      return show;
    }
  }

  Future<void> UpdateShowIdStats() async {
    Map <String, dynamic> Json = {
      "uid": userlocal['uid'],
      "stats": [
        {
          "sid": show.showid.toString(),
          "stat": "show_clicks",
          "val": "inc"
        }
      ]
    };
    postUrl($serviceURLupdatestats, Json);
  }

  void refreshdata() {
    _dataRequiredForBuild = fetchData();
    setState(() {});
  }

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems = [];
  late ListItem _selectedItem;

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems() {
    List<DropdownMenuItem<ListItem>> items = [];
    for (var i=1; i <= show.totalseasons; i++) {
      items.add(
        DropdownMenuItem(
          child: Text("Season " + i.toString()),
          value: ListItem(i, "Season " + i.toString()),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async {
        if(backroute == 1) {
          return true;
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                HomeScreen(
                  refresh: false,
                )
            ),
            (Route<dynamic> route) => false
          );
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title:  Text(
            show.showname,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget> [
            Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Map<int, Show> filteredshows = Map();
                  showsHome.shows.forEach((key, value) {
                    if(showsHome.shows[key]!.channel == channel.channel) {
                      filteredshows.putIfAbsent(
                          showsHome.shows[key]!.showid, () => showsHome.shows[key]!);
                    }
                  });

                  Navigator.of(context).push(
                      MyFadeRoute(builder: (context) => SearchScreen(
                        showsPassed: filteredshows,
                        searchHint: 'Show or Year Released',
                      ))
                  );
                },
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: channel.logoUrl,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
            ),
          ]
        ),
        body: Container(
          color: Colors.black,
          child: ListView(
                children: [
                  CachedNetworkImage(
                    imageUrl: show.posterUrl,
                    height: deviceSize.height/(isWeb ? 2:3),
                    width: deviceSize.width,
                    fit:BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget> [
                      Conditional.single(
                        conditionBuilder: (BuildContext context) =>
                        (show.showtype == 'SZN'),
                        widgetBuilder: (BuildContext context) =>
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                              child: Text(
                                'Seasons\n' + show.totalseasons.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ),
                        fallbackBuilder: (BuildContext context) =>
                          SizedBox(width: 0.0,), context: context,
                      ),
                      SizedBox(width: 10.0,),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: Text(
                            'Episodes\n' + show.totalepisodes.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ),
                      SizedBox(width: 10.0,),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: Text(
                            'Released\n' + DateFormat("MMM").format(show.releaseDatetime) + ' ' + show.releaseDatetime.year.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ),
                      SizedBox(width: 10.0,),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: Text(
                            'Views\n' + numdisplay(show.viewCount),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<Show>(
                    future: _dataRequiredForBuild,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: $circularbackgroundcolor,
                            valueColor: new AlwaysStoppedAnimation<Color>($circularstrokecolor),
                            strokeWidth: $circularstrokewidth,
                          ),
                        );
                      } else if (snapshot.hasData && error == 0) {
                        return SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: ListView(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                children: <Widget>[
                                  Conditional.single(
                                    conditionBuilder: (BuildContext context) =>
                                    (show.showtype == 'SZN'),
                                    widgetBuilder: (BuildContext context) =>
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget> [
                                          Container(
                                              height: 50,
                                              //width: 100,
                                              child: Center(
                                                child: Text(
                                                  'Seasons',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            height: 50,
                                            //width: 100,
                                            child: DropdownButton<ListItem>(
                                                value: _selectedItem,
                                                items: _dropdownMenuItems,
                                                icon: Icon(Icons.arrow_downward, color: Colors.white,),
                                                dropdownColor: Colors.black,
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.white,
                                                ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedItem = value!;
                                                    seasonno = value.value;
                                                  });
                                                }
                                            ),
                                          ),
                                        ]
                                      ),
                                    fallbackBuilder: (BuildContext context) =>
                                        SizedBox(height: 0.0,), context: context,
                                  ),
                                  SizedBox(height: 10),
                                  Conditional.single(
                                    conditionBuilder: (BuildContext context) =>
                                    (_lastplayedepisode > 0),
                                    widgetBuilder: (BuildContext context) =>
                                      ListView(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        children: <Widget> [
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              'Continue Watching',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: 1,
                                            itemBuilder: (context, index) {
                                            return GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () {
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlayScreen(
                                                              show: showLocal,
                                                              channel: channel,
                                                              seasonno: _lastplayedseason,
                                                              episodeno: _lastplayedepisode,
                                                          )
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                child: ListTile(
                                                  leading: CachedNetworkImage(
                                                    imageUrl: (showLocal.seasons[_lastplayedseason]!.episodes[_lastplayedepisode]!.episodeThumbnail),
                                                    width: 100,
                                                    fit: BoxFit.fitWidth,
                                                    alignment: Alignment.topLeft,
                                                    errorWidget: (context, url, error) => CachedNetworkImage(
                                                      imageUrl: (showLocal.posterUrl),
                                                      width: 100,
                                                      fit: BoxFit.fitWidth,
                                                      alignment: Alignment.topLeft,
                                                    )
                                                  ),
                                                  title: Text(
                                                    'Episode ' +
                                                        showLocal.seasons[_lastplayedseason]!.episodes[_lastplayedepisode]!.episodeno
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Roboto',
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  subtitle: Text(
                                                    showLocal.seasons[_lastplayedseason]!.episodes[_lastplayedepisode]!.episodetitle,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight: FontWeight.w400,
                                                      color: Color(0xffaaaaaa),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        ),
                                      ]
                                    ),
                                    fallbackBuilder: (BuildContext context) =>
                                    SizedBox(height: 0.0,), context: context,
                                  ),
                                  SizedBox(height: 20.0,),
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      'All Episodes',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: showLocal.seasons[seasonno]!.episodes.length,
                                    itemBuilder: (context, index) {
                                      int key = showLocal.seasons[seasonno]!.episodes.keys.elementAt(index);
                                      if(showLocal.seasons[seasonno]!.episodes[key] != null) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayScreen(
                                                          show: showLocal,
                                                          channel: channel,
                                                          seasonno: seasonno,
                                                          episodeno: key,
                                                      )
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            child: ListTile(
                                              leading: CachedNetworkImage(
                                                imageUrl: (showLocal.seasons[seasonno]!.episodes[key]!.episodeThumbnail),
                                                width: 100,
                                                fit: BoxFit.fitWidth,
                                                alignment: Alignment.topLeft,
                                                errorWidget: (context, url, error) => CachedNetworkImage(
                                                    imageUrl: (showLocal.posterUrl),
                                                    width: 100,
                                                    fit: BoxFit.fitWidth,
                                                    alignment: Alignment.topLeft,
                                                )
                                              ),
                                              title: Text(
                                                'Episode ' +
                                                    showLocal.seasons[seasonno]!.episodes[key]!.episodeno
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              subtitle: Text(
                                                showLocal.seasons[seasonno]!.episodes[key]!.episodetitle,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffaaaaaa),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox(height: 0,);
                                      }
                                    },
                                  ),
                                ]
                            )
                        );
                      }
                      else {
                        return Scaffold(
                          backgroundColor: Colors.black,
                          body: Center(
                            child: ListView(
                                shrinkWrap: true,
                                children: <Widget> [
                                  Image.asset(
                                    $iconpath,
                                    height: 200,
                                  ),
                                  SizedBox(height: 100),
                                  Image.asset(
                                    $problempath,
                                    height: 50,
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    "An Error Occured\n" + "Please check your connection & try again",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      height: 1.5,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 25),
                                  Align(
                                    child:ElevatedButton(
                                      onPressed: () {
                                        refreshdata();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: BorderSide(color: Colors.grey, width: 2),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Refresh',
                                          style: TextStyle(
                                              fontSize: 25, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
          ),
        bottomNavigationBar: CustomBottomNavBar(currentscreen: "List",),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}