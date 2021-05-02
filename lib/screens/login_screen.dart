import 'dart:ui';
import 'package:daikhopk/widgets/apple_sign_in_button.dart';
import 'package:daikhopk/widgets/facebook_sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/widgets/google_sign_in_button.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late TextEditingController textControllerEmail;
  late  FocusNode textFocusNodeEmail;

  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;

  late  String loginStatus;
  Color loginStringColor = Colors.green;

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
    return FutureBuilder<bool>(
      future: dataRequiredforLogin,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WillPopScope(
            onWillPop: _onBackPressed,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  brightness: Brightness.dark,
                ),
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
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) =>
                                  canAppleLogin,
                                widgetBuilder: (BuildContext context) =>
                                    Center(child: AppleButton()),
                                fallbackBuilder: (BuildContext context) =>
                                    Center(child: GoogleButton()),
                              ),
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
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: $circularbackgroundcolor,
              valueColor: new AlwaysStoppedAnimation<Color>(
                  $circularstrokecolor),
              strokeWidth: $circularstrokewidth,
            ),
          );
        }
      }
    );
  }
}