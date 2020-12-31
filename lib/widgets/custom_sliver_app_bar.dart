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
      expandedHeight: 400.0,
      floating: false,
      pinned: false,
      snap: false,
      backgroundColor: Color(0xff0f0f0f),
      leading: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        direction: Axis.vertical,
        children: <Widget> [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black
            ),
            child: Image.asset(
              $logopath,
              width: 48,
              height: 48,
            ),
          ),
          Text(
            "Featured Shows",
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ]
      ),
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xff0f0f0f),
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
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
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
                    )
                  ]
                )
              );
            },
            autoplay: true,
            autoplayDelay: 5000,
            layout: SwiperLayout.DEFAULT,
            pagination: new SwiperPagination(alignment: Alignment.bottomLeft),
          )
        ),
      ),
    );
  }
}
