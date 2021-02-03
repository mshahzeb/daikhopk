import 'package:daikhopk/screens/splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CustomSliverAppBar extends StatelessWidget {
  final List<int> featured;
  CustomSliverAppBar({@required this.featured});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: deviceSize.height/2.5,
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
          background: Swiper(
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: CachedNetworkImage(
                        imageUrl: showsHome.shows[featured[index]].posterUrl,
                        height: deviceSize.height/2,
                        width: deviceSize.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 10),
                      child: CachedNetworkImage(
                        imageUrl: showsHome.channels[showsHome.shows[featured[index]].channel].logoUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        showsHome.shows[featured[index]].showname,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Comfortaa',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        numdisplay(showsHome.shows[featured[index]].viewCount) + ' Views',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Comfortaa',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
              alignment: Alignment.topCenter,
              builder: new DotSwiperPaginationBuilder(
                color: Colors.black, activeColor: Colors.redAccent),
            ),
          ),
        )
      ),
    );
  }
}
