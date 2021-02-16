import 'package:daikhopk/constants.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/urlLauncher.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => new _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var msgController1 = TextEditingController();
  var msgController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: const Text('Contact Us'),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey1,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Report a Missing Show ?',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                ),
              ),
              TextFormField(
                controller: msgController1,
                decoration: InputDecoration(
                  hintText: 'Show Name, Channel Name & Link (Optional)',
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w300
                  ),
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)
                  ),
                ),
                maxLines: 5,
                minLines: 3,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey1.currentState.validate()) {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      msgController1.clear();
                      // If the form is valid, display a Snackbar.
                      String message = 'We have received your message! We will get back to you soon.';
                      var snackBar = SnackBar(content: Text(message), duration: Duration(milliseconds: 5000));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    'Report',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
              ]
            ),
          ),
          SizedBox(height: 25.0,),
          Form(
            key: _formKey2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'OR Write to Us',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  ),
                ),
                TextFormField(
                  controller: msgController2,
                  decoration: InputDecoration(
                    hintText: 'Enter your message here',
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300
                    ),
                    contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)
                    ),
                  ),
                  maxLines: 20,
                  minLines: 10,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w300
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey2.currentState.validate()) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        msgController2.clear();
                        // If the form is valid, display a Snackbar.
                        String message = 'We have received your message! We will get back to you soon.';
                        var snackBar = SnackBar(content: Text(message), duration: Duration(milliseconds: 5000));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      'Send',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
            SizedBox(height: 25.0,),
            Text(
              'OR Send us an email directly',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                color: Colors.redAccent,
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  String uri = 'mailto:' + $supportemail + '?subject=daikho.pk%20Support%20User:%20' + userlocal['userEmail'];
                  launchUrl(uri);
                },
                child: Text(
                  'Email',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ],
        ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "ContactUs",),
    );
  }
}