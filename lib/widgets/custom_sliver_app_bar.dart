import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/screens/list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/constants.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Map<int, Show> shows;
  final Map<String, Channel> channels;
  CustomSliverAppBar({@required this.shows, this.channels});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: deviceSize.height/2,
      floating: false,
      pinned: false,
      snap: false,
      backgroundColor: Colors.black,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          Container(
            child: Image.asset(
                $iconcirclepath,
                width: 50,
                height: 50,
            ),
          ),
        ]
      ),
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: FlexibleSpaceBar(
          centerTitle: false,
          background: Swiper(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              int key = shows.keys.elementAt(index);
              return GestureDetector (
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListScreen(
                      show: shows[key],
                      channel: channels[shows[key].channel],
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
                        imageUrl: shows[key].posterUrl,
                        height: deviceSize.height/2,
                        width: deviceSize.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 10),
                      child: CachedNetworkImage(
                        imageUrl: channels[shows[key].channel].logoUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        shows[key].showname,
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
                        numdisplay(shows[key].viewCount) + ' Views',
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
