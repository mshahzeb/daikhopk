import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:daikhopk/utils/authentication.dart';
import 'package:flutter/material.dart';

class AppleButton extends StatefulWidget {
  @override
  _AppleButtonState createState() => _AppleButtonState();
}

class _AppleButtonState extends State<AppleButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 500,
      child: AppleSignInButton(
        //style: ButtonStyle.black,
        type: ButtonType.continueButton,
        onPressed: () {
          signInWithApple();
        },
      ),
    );
  }
}
