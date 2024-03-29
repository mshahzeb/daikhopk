import 'package:daikhopk/screens/account_screen.dart';
import 'package:daikhopk/screens/category_screen.dart';
import 'package:daikhopk/screens/channels_screen.dart';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/screens/livechannels_screen.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CustomBottomNavBar extends StatefulWidget {
  final String currentscreen;
  CustomBottomNavBar({required final this.currentscreen});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState(
    currentscreen: currentscreen,
  );
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  String currentscreen = '';
  _CustomBottomNavBarState({required final this.currentscreen});

  bool refresh = false;

  static const Widget LiveWidget = Text(
    'Index 3: Live',
    style: optionStyle,
  );
  static const Widget CategoryWidget = Text(
    'Index 3: Category'
        '',
    style: optionStyle,
  );

  static const TextStyle optionStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Roboto');
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Account',
      style: optionStyle,
    ),
    Text(
      'Index 1: Channels',
      style: optionStyle,
    ),
    Text(
      'Index 2: Home',
      style: optionStyle,
    ),
    isIOS ? CategoryWidget : LiveWidget,
    Text(
      'Index 4: Explore',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      switch(index) {
        case 0: {
          Navigator.of(context).push(
              MyFadeRoute(builder: (context) => AccountScreen())
          );
        }
        break;

        case 1: {
          Navigator.of(context).push(
              MyFadeRoute(builder: (context) => ChannelScreen(
                channelsPassed: showsHome.channels,
                searchHint: "Search for Channels",
              ))
          );
        }
        break;

        case 2: {
          if(currentscreen == "Home") {
            refresh = true;
          } else {
            refresh = false;
          }
          Navigator.of(context).pushAndRemoveUntil(
            MyFadeRoute(builder: (context) => HomeScreen(refresh: refresh)),
            (Route<dynamic> route) => false
          );
        }
        break;

        case 3: {
          if(isIOS) {
            Navigator.of(context).push(
                MyFadeRoute(builder: (context) => CategoryScreen(
                ))
            );
          } else {
            Navigator.of(context).push(
                MyFadeRoute(builder: (context) => LiveChannelScreen(
                  channelsPassed: showsHome.livechannels,
                  searchHint: "Search for Live Channels",
                ))
            );
          }
        }
        break;

        case 4: {
          Navigator.of(context).push(
            MyFadeRoute(builder: (context) => SearchScreen(
              showsPassed: showsHome.shows,
              searchHint: 'Show, Channel or Year Released',
              shuffle: true,
            ))
          );
        }
        break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type : BottomNavigationBarType.fixed,        
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              LineAwesomeIcons.user,
              color: Colors.white,
              size: 25.0,
            ),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LineAwesomeIcons.film,
              color: Colors.blueAccent,
              size: 25.0,
            ),
            label: 'Channels',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/logo/daikho_icon_cropped.png'),
              color: Colors.redAccent,
              size: 35.0,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LineAwesomeIcons.television,
              color: Colors.amberAccent,
              size: 25.0,
            ),
            label: isIOS ? 'Category' : 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LineAwesomeIcons.search,
              color: Colors.white,
              size: 25.0,
            ),
            label: 'Explore',
          ),
        ],
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        fixedColor: Colors.white,
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        onTap: _onItemTapped,
      );
  }
}