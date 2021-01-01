import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/screens/search_screen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  int selectedindex;
  CustomBottomNavBar({@required final this.selectedindex});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState(
    selectedIndex: selectedindex,
  );
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int selectedIndex;

  _CustomBottomNavBarState({@required final this.selectedIndex});

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
        case 0: { print('1'); }
        break;

        case 1: {
          Navigator.of(context).push(
            MyFadeRoute(builder: (context) => HomeScreen())
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
      selectedIndex = index;
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
        currentIndex: selectedIndex,
        selectedItemColor: Colors.redAccent,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        // fixedColor: Colors.grey,

        onTap: _onItemTapped,
      );
  }
}

class MyFadeRoute<T> extends MaterialPageRoute<T> {
  MyFadeRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    //if (settings.isInitialRoute)
    //  return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}