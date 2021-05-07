import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen();
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  _CategoryScreenState();
  bool loading = false;
  Map <String, dynamic> CategoryList = Map();
  Map<int, Show> filteredshows = Map();
  bool shuffle = false;

  @override
  void initState() {
    super.initState();

    CategoryList.putIfAbsent('Currently Running', () => LineAwesomeIcons.play);
    CategoryList.putIfAbsent('Completed', () => LineAwesomeIcons.check);
    CategoryList.putIfAbsent('Most Liked', () => LineAwesomeIcons.thumbs_up);
    CategoryList.putIfAbsent('Most Watched', () => LineAwesomeIcons.eye);
    CategoryList.putIfAbsent('Released This Year', () => LineAwesomeIcons.redo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
              padding: EdgeInsets.only(top: 80.00),
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                crossAxisCount: (deviceSize.width/($defaultWidth)).floor(),
                itemCount: CategoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = CategoryList.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      filteredshows.clear();
                      switch(index) {
                      //['New Episodes','Released Recently','Currently Running','Most Watched - All time','Top Rated - All time']
                        case 0: {
                          shuffle = true;
                          filteredshows = listdataHome[2].data;
                        }
                        break;

                        case 1: {
                          shuffle = true;
                          showsHome.shows.forEach((key, value) {
                            if(showsHome.shows[key]!.completed == 1) {
                              filteredshows.putIfAbsent(
                                  showsHome.shows[key]!.showid, () => showsHome.shows[key]!);
                            }
                          });
                        }
                        break;

                        case 2: {
                          shuffle = false;
                          filteredshows = listdataHome[4].data;
                        }
                        break;

                        case 3: {
                          shuffle = false;
                          filteredshows = listdataHome[3].data;
                        }
                        break;

                        case 4: {
                          shuffle = true;
                          DateTime currDate = DateTime.now();
                          showsHome.shows.forEach((key, value) {
                            if(showsHome.shows[key]!.releaseDatetime.year == currDate.year) {
                              filteredshows.putIfAbsent(
                                  showsHome.shows[key]!.showid, () => showsHome.shows[key]!);
                            }
                          });
                        }
                        break;
                      }

                      Navigator.of(context).push(
                          MyFadeRoute(builder: (context) => SearchScreen(
                            showsPassed: filteredshows,
                            searchHint: 'Show or Year Released',
                            shuffle: shuffle,
                          ))
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Icon(
                          CategoryList[key],
                          color: Colors.white,
                          size: 50.0,
                        ),
                        SizedBox(height: 5.0,),
                        SizedBox(
                          height: 30,
                          width: $defaultWidth,
                          child: Text(
                            key,
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
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "Category",),
    );
  }
}