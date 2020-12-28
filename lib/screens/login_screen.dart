import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/widgets/google_sign_in_button.dart';

import 'package:daikhopk/utils/routeNames.dart';
import 'package:daikhopk/utils/authentication.dart';

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

  String _validatePassword(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Length of password should be greater than 6';
      }
    }

    return null;
  }

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerEmail.text = null;
    textControllerPassword.text = null;
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFE6E6E6),
            body:
            Container(
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: deviceSize.height / 2.4,
                          width: deviceSize.width / 3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage($logopath),
                            ),),),

                        Container(
                          child: Form(
                            key: _userLoginFormKey,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 15, left: 10, right: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)),
                                child: Container(
                                  color: Colors.black87,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text("Sign into your Account",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0,
                                            right: 14,
                                            left: 14,
                                            bottom: 8),
                                        child: TextField(
                                          focusNode: textFocusNodeEmail,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          textInputAction: TextInputAction.next,
                                          controller: textControllerEmail,
                                          autofocus: false,
                                          onChanged: (value) {
                                            setState(() {
                                              _isEditingEmail = true;
                                            });
                                          },
                                          onSubmitted: (value) {
                                            textFocusNodeEmail.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(
                                                textFocusNodePassword);
                                          },
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.blueGrey[800],
                                                width: 3,
                                              ),
                                            ),
                                            filled: true,
                                            hintStyle: new TextStyle(
                                              color: Colors.blueGrey[300],
                                            ),
                                            hintText: "Email",
                                            fillColor: Colors.white,
                                            errorText: _isEditingEmail
                                                ? _validateEmail(
                                                textControllerEmail.text)
                                                : null,
                                            errorStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0,
                                            right: 14,
                                            left: 14,
                                            bottom: 8),
                                        child: TextField(
                                          focusNode: textFocusNodePassword,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          controller: textControllerPassword,
                                          obscureText: true,
                                          autofocus: false,
                                          onChanged: (value) {
                                            setState(() {
                                              _isEditingPassword = true;
                                            });
                                          },
                                          onSubmitted: (value) {
                                            textFocusNodePassword.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(
                                                textFocusNodePassword);
                                          },
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.blueGrey[800],
                                                width: 3,
                                              ),
                                            ),
                                            filled: true,
                                            hintStyle: new TextStyle(
                                              color: Colors.blueGrey[300],
                                            ),
                                            hintText: "Password",
                                            fillColor: Colors.white,
                                            errorText: _isEditingPassword
                                                ? _validatePassword(
                                                textControllerPassword.text)
                                                : null,
                                            errorStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16,),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: double.maxFinite,
                                                child: FlatButton(
                                                  color: Colors.blueGrey[800],
                                                  hoverColor: Colors
                                                      .blueGrey[900],
                                                  highlightColor: Colors.black,
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isLoggingIn = true;
                                                      textFocusNodeEmail
                                                          .unfocus();
                                                      textFocusNodePassword
                                                          .unfocus();
                                                    });
                                                    if (_validateEmail(
                                                        textControllerEmail
                                                            .text) ==
                                                        null &&
                                                        _validatePassword(
                                                            textControllerPassword
                                                                .text) ==
                                                            null) {
                                                      await signInWithEmailPassword(
                                                          textControllerEmail
                                                              .text,
                                                          textControllerPassword
                                                              .text)
                                                          .then((result) {
                                                        if (result != null) {
                                                          print(result);
                                                          setState(() {
                                                            loginStatus =
                                                            'You have successfully logged in';
                                                            loginStringColor =
                                                                Colors.green;
                                                          });
                                                          Future.delayed(
                                                              Duration(milliseconds: 500),
                                                                  () {Navigator.of(context).pushNamedAndRemoveUntil(RouteName.Home, (Route<dynamic> route) => false);
                                                              });
                                                        }
                                                      }).catchError((error) {
                                                        print(
                                                            'Login Error: $error');
                                                        setState(() {
                                                          loginStatus =
                                                          'Error occured while logging in';
                                                          loginStringColor =
                                                              Colors.red;
                                                        });
                                                      });
                                                    } else {
                                                      setState(() {
                                                        loginStatus =
                                                        'Please enter email & password';
                                                        loginStringColor =
                                                            Colors.red;
                                                      });
                                                    }
                                                    setState(() {
                                                      _isLoggingIn = false;
                                                      textControllerEmail.text =
                                                      '';
                                                      textControllerPassword
                                                          .text = '';
                                                      _isEditingEmail = false;
                                                      _isEditingPassword =
                                                      false;
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 15.0,
                                                      bottom: 15.0,
                                                    ),
                                                    child: _isLoggingIn
                                                        ? SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: CircularProgressIndicator(
                                                        backgroundColor: $circularbackgroundcolor,
                                                        valueColor: new AlwaysStoppedAnimation<Color>($circularstrokecolor),
                                                        strokeWidth: $circularstrokewidth,
                                                      ),
                                                    )
                                                        : Text(
                                                      'Log in',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: double.maxFinite,
                                                child: FlatButton(
                                                  color: Colors.blueGrey[800],
                                                  hoverColor: Colors
                                                      .blueGrey[900],
                                                  highlightColor: Colors.black,
                                                  onPressed: () async {
                                                    setState(() {
                                                      textFocusNodeEmail
                                                          .unfocus();
                                                      textFocusNodePassword
                                                          .unfocus();
                                                    });
                                                    if (_validateEmail(
                                                        textControllerEmail
                                                            .text) ==
                                                        null &&
                                                        _validatePassword(
                                                            textControllerPassword
                                                                .text) ==
                                                            null) {
                                                      setState(() {
                                                        _isRegistering = true;
                                                      });
                                                      await registerWithEmailPassword(
                                                          textControllerEmail
                                                              .text,
                                                          textControllerPassword
                                                              .text)
                                                          .then((result) {
                                                        if (result != null) {
                                                          setState(() {
                                                            loginStatus =
                                                            'You have registered successfully';
                                                            loginStringColor =
                                                                Colors.green;
                                                          });
                                                          print(result);
                                                          Future.delayed(
                                                              Duration(
                                                                  milliseconds: 500),
                                                                  () {
                                                                Navigator.of(
                                                                    context)
                                                                    .pushNamedAndRemoveUntil
                                                                  (RouteName
                                                                    .Home, (
                                                                    Route<
                                                                        dynamic> route) => false
                                                                );
                                                              });
                                                        }
                                                      }).catchError((error) {
                                                        print(
                                                            'Registration Error: $error');
                                                        setState(() {
                                                          loginStatus =
                                                          'Error occured while registering';
                                                          loginStringColor =
                                                              Colors.red;
                                                        });
                                                      });
                                                    } else {
                                                      setState(() {
                                                        loginStatus =
                                                        'Please enter email & password';
                                                        loginStringColor =
                                                            Colors.red;
                                                      });
                                                    }
                                                    setState(() {
                                                      _isRegistering = false;

                                                      textControllerEmail.text =
                                                      '';
                                                      textControllerPassword
                                                          .text = '';
                                                      _isEditingEmail = false;
                                                      _isEditingPassword =
                                                      false;
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 15.0,
                                                      bottom: 15.0,
                                                    ),
                                                    child: _isRegistering
                                                        ? SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(
                                                          Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                        : Text(
                                                      'Sign up',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      loginStatus != null
                                          ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 20.0,
                                          ),
                                          child: Text(
                                            loginStatus,
                                            style: TextStyle(
                                              color: loginStringColor,
                                              fontSize: 14,
                                              // letterSpacing: 3,
                                            ),
                                          ),
                                        ),
                                      )
                                          : Container(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40.0,
                                          right: 40.0,
                                        ),
                                        child: Container(
                                          height: 1,
                                          width: double.maxFinite,
                                          color: Colors.blueGrey[200],
                                        ),
                                      ),
                                      SizedBox(height: 16,),
                                      Center(child: GoogleButton()),
                                      SizedBox(height: 16,),
                                    ],),
                                ),),
                            ),),
                        )
                      ],),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}