import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CustomSliverAppBar extends StatelessWidget {
  final List<int> featured;
  CustomSliverAppBar({@required this.featured});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: deviceSize.height/2.45,
      floating: false,
      pinned: false,
      snap: false,
      backgroundColor: Colors.black,
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: FlexibleSpaceBar(
          centerTitle: false,
          background: Container(
            margin: EdgeInsets.all(10),
            child: Swiper(
              itemCount: featured.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector (
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListScreen(
                        show: showsHome.shows[featured[index]],
                        channel: showsHome.channels[showsHome.shows[featured[index]].channel],
                        refresh: true,
                      )
                      ),
                    );
                  },
                  child: Stack(
                    children: <Widget> [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: CachedNetworkImage(
                          imageUrl: showsHome.shows[featured[index]].posterUrl,
                          //height: deviceSize.height/2,
                          width: deviceSize.width,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10, bottom: 50),
                        child: GestureDetector(
                          onTap: () {
                            Map<int, Show> filteredshows = Map();
                            showsHome.shows.forEach((key, value) {
                              if(showsHome.shows[key].channel == showsHome.channels[showsHome.shows[featured[index]].channel].channel) {
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
                          child: CachedNetworkImage(
                            imageUrl: showsHome.channels[showsHome.shows[featured[index]].channel].logoUrl,
                            height: 50,
                            width: 50,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          showsHome.shows[featured[index]].showname,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          numdisplay(showsHome.shows[featured[index]].viewCount) + ' Views',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Color(0xffaaaaaa),
                          ),
                        ),
                      ),
                    ]
                  )
                );
              },
              autoplay: true,
              autoplayDelay: 5000,
              layout: SwiperLayout.DEFAULT,
              pagination: new SwiperPagination(
                alignment: Alignment.bottomCenter,
                  builder: new DotSwiperPaginationBuilder(
                    color: Color(0xffaaaaaa), activeColor: Color(0xffDF1B25),
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
