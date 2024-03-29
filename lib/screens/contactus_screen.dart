import 'package:daikhopk/constants.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/urlLauncher.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:daikhopk/utils/webservice.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => new _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var msgController1 = TextEditingController();
  var msgController2 = TextEditingController();

  void sendMessage(final String message, final String type) async {
    if(type == 'contactus') {
      Map <String, dynamic> Json = {
        "uid": userlocal['uid'],
        "email": userlocal['userEmail'],
        "message": message
      };
      String response = await postUrl($serviceURLcontact + '/' + type, Json);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'Contact Us',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Form(
              key: _formKey1,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Report a Missing Show ?',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
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
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey1.currentState!.validate()) {

                        sendMessage(msgController1.text,'contactus');

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
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
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
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        sendMessage(msgController2.text,'contactus');
                        if (_formKey2.currentState!.validate()) {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          msgController2
                          .clear();
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
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Text(
                'OR Send us an email directly',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 50,
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
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "ContactUs",),
    );
  }
}