import 'package:daikhopk/screens/home_screen.dart';
import 'package:daikhopk/utils/authentication.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatefulWidget {
  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey, width: 2),
        ),
        color: Colors.black38,
      ),
      child: OutlineButton(
        highlightColor: Colors.redAccent,
        splashColor: Colors.grey,
        onPressed: () async {
          setState(() {
            _isProcessing = true;
          });
          await signInWithGoogle().then((result) {
            print(result);
            if (result != null) {
              Navigator.of(context)
                  .pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => HomeScreen(refresh: false)
                  ),
                      (Route<dynamic> route) => false
              );
            }
          }).catchError((error) {
            print('Registration Error: $error');
          });
          setState(() {
            _isProcessing = false;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey, width: 3),
        ),
        highlightElevation: 0,
        // borderSide: BorderSide(color: Colors.blueGrey, width: 3),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: _isProcessing
              ? CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          )
          : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/google-logo.png"),
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
