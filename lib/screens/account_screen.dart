import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => new _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text('My Account'),
      ),
      body: new Center(
          child: new Text("Your Name is: " + userlocal['name'])),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}