import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daikhopk/screens/helpandsupport_screen.dart';
import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/screens/viewinghistory_screen.dart';
import 'package:daikhopk/utils/authentication.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/utils/urlLauncher.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../constants.dart';
import 'contactus_screen.dart';
import 'login_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => new _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'My Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 25,
              horizontal: isWeb ? $webbuttonspadding:25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  padding: EdgeInsets.all(8),
                  decoration: avatarDecoration,
                  child: Container(
                    decoration: avatarDecoration,
                    padding: EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(userlocal['userImageUrl']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  userlocal['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins"),
                ),
                Text(
                  userlocal['userEmail'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(height: 50),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "Account",),
    );
  }
}

BoxDecoration avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.black38,
);

class ProfileListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          ProfileListItem(
            icon: LineAwesomeIcons.history,
            text: 'Viewing History',
          ),
          ProfileListItem(
            icon: LineAwesomeIcons.question,
            text: 'Help & Support',
          ),
          ProfileListItem(
            icon: LineAwesomeIcons.thumbs_up,
            text: 'Rate Us',
          ),
          ProfileListItem(
            icon: LineAwesomeIcons.alternate_sign_out,
            text: 'Logout',
            hasNavigation: false,
          ),
        ],
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(this.text == 'Logout') {
          signOut();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }), ModalRoute.withName('/'));
        } else if (this.text == 'Viewing History') {
          Navigator.of(context).push(
              MyFadeRoute(builder: (context) => ViewingHistoryScreen())
          );
        } else if (this.text == 'Help & Support') {
          Navigator.of(context).push(
              MyFadeRoute(builder: (context) => HelpAndSupportScreen())
          );
        } else if (this.text == 'Rate Us') {
          if(isWeb) {
            launchUrl($facebookurl);
          } else {
            rateMyApp.init().then((_) {
              if (true) {
                rateMyApp.showStarRateDialog(
                  context,
                  title: 'Like our App?',
                  message: 'Please Leave a Rating',
                  actionsBuilder: (_, stars) {
                    return [
                      // Returns a list of actions (that will be shown at the bottom of the dialog).
                      TextButton(
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () async {
                          print('Thanks for the ' +
                              (stars == null ? '0' : stars.round().toString()) +
                              ' star(s) !');
                          if (stars != null && (stars >= 4)) {
                            String message = 'Thank you!';
                            var snackBar = SnackBar(content: Text(message),
                                duration: Duration(milliseconds: 5000));
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar);
                            Navigator.pop<RateMyAppDialogButton>(
                                context, RateMyAppDialogButton.rate);
                            if (!isWeb) {
                              if(Platform.isAndroid) {
                                launchUrl($playstorelink);
                              } else if (Platform.isIOS) {
                                launchUrl($appstorelink);
                              }
                            }

                          } else if (stars != null && (stars <= 3)) {
                            String message = 'Please tell us how can we make it better?';
                            var snackBar = SnackBar(content: Text(message),
                                duration: Duration(milliseconds: 5000));
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar);
                            Navigator.pop<RateMyAppDialogButton>(
                                context, RateMyAppDialogButton.rate);
                            Navigator.of(context).push(
                                MyFadeRoute(
                                    builder: (context) => ContactUsScreen())
                            );
                          }
                        },
                      ),
                    ];
                  },
                  dialogStyle: DialogStyle(
                    titleAlign: TextAlign.center,
                    messageAlign: TextAlign.center,
                    messagePadding: EdgeInsets.only(bottom: 20.0),
                    titleStyle: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                    messageStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  starRatingOptions: StarRatingOptions(
                    starsBorderColor: Colors.redAccent,
                    starsFillColor: Colors.redAccent,
                  ),
                  onDismissed: () =>
                      rateMyApp.callEvent(
                          RateMyAppEventType.laterButtonPressed),
                );
              }
            });
          }
        }
      },
      child: Container(
        height: 55,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ).copyWith(
          bottom: 10,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: 25,
            ),
            SizedBox(width: 15),
            Text(
              this.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins"),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                LineAwesomeIcons.angle_right,
                size: 25,
              ),
          ],
        ),
      ),
    );
  }
}