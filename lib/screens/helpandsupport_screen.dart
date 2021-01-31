import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatefulWidget {
  @override
  _HelpAndSupportState createState() => new _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupportScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text('Help & Support'),
      ),
      body: Stack(
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "HelpAndSupport",),
    );
  }
}