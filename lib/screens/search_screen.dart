import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => new _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Explore'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    var snackBar = SnackBar(content: Text('You wrote $value!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _SearchScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: new Center(
          child: new Text("Don't look at me! Press the search button!")),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}