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
  CustomSliverAppBar({@required this.shows});

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
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black
            ),
            child: Image.asset(
                $iconpath,
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
                    )
                    ),
                  );
                },
                child: Stack(
                  children: <Widget> [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: CachedNetworkImage(
                          imageUrl: shows[key].posterUrl,
                          height: deviceSize.height/2,
                          width: deviceSize.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        shows[key].showname + ' by ' + shows[key].channel,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Comfortaa',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]
                )
              );
            },
            autoplay: true,
            autoplayDelay: 5000,
            layout: SwiperLayout.DEFAULT,
            pagination: new SwiperPagination(
              alignment: Alignment.bottomLeft,
              builder: new DotSwiperPaginationBuilder(
              color: Colors.white, activeColor: Colors.redAccent),
            ),
          ),
        )
      ),
    );
  }
}
