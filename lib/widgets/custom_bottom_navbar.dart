import 'package:daikhopk/screens/account_screen.dart';
import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final String currentscreen;
  CustomBottomNavBar({@required final this.currentscreen});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState(
    currentscreen: currentscreen,
  );
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final String currentscreen;
  _CustomBottomNavBarState({@required final this.currentscreen});

  bool refresh;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 11, fontWeight: FontWeight.w300, fontFamily: 'Comfortaa');
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: My Account',
      style: optionStyle,
    ),
    Text(
      'Index 1: Home',
      style: optionStyle,
    ),
    Text(
      'Index 2: Search',
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

        case 2: {
          Navigator.of(context).push(
            MyFadeRoute(builder: (context) => SearchScreen())
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        fixedColor: Colors.white,

        onTap: _onItemTapped,
      );
  }
}