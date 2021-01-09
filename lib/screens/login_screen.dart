import 'dart:ui';
import 'package:daikhopk/widgets/facebook_sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/widgets/google_sign_in_button.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  GlobalKey<FormState> _userLoginFormKey = GlobalKey();

  TextEditingController textControllerEmail;
  FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  TextEditingController textControllerPassword;
  FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  bool _isRegistering = false;
  bool _isLoggingIn = false;

  String loginStatus;
  Color loginStringColor = Colors.green;

  String _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body:
            Container(
              color: Colors.black,
              child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                  children: <Widget>[
                    Container(
                      height: deviceSize.height / 2,
                      width: deviceSize.width,
                      child: Image.asset(
                        $logopath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.fitHeight
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(child: GoogleButton()),
                    SizedBox(height: 25,),
                    Center(child: FacebookButton()),
                    ],
                ),
              )
              ],
            )
          ),
        ),
      ),
    );
  }
}