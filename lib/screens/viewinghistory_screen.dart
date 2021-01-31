import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class ViewingHistoryScreen extends StatefulWidget {
  @override
  _ViewingHistoryScreenState createState() => new _ViewingHistoryScreenState();
}

class _ViewingHistoryScreenState extends State<ViewingHistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text('Viewing History'),
      ),
      body: Stack(
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "ViewingHistory",),
    );
  }
}