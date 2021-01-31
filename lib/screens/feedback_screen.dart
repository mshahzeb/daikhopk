import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => new _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text('Feedback'),
      ),
      body: Stack(
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "Feedback",),
    );
  }
}