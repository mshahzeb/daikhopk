import 'package:daikhopk/screens/splash_screen.dart';
import 'package:daikhopk/utils/customroute.dart';
import 'package:daikhopk/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:daikhopk/utils/urlLauncher.dart';

import '../constants.dart';
import 'contactus_screen.dart';

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
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'Help & Support',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
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
                  height: 80,
                  decoration: avatarDecoration,
                  child: Image.asset(
                    $iconcirclepath,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: (isWeb ? $webbuttonspadding:10),
                  ),
                  child: Text(
                    'daikho.pk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  $aboutus,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ProfileListItem(
                  icon: LineAwesomeIcons.history,
                  text: 'FAQs',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.university,
                  text: 'Privacy Policy',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.newspaper,
                  text: 'Terms & Conditions',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.phone,
                  text: 'Contact Us',
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentscreen: "HelpAndSupport",),
    );
  }
}

BoxDecoration avatarDecoration = BoxDecoration(
  shape: BoxShape.circle,
  color: Colors.black38,
);

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.text == 'FAQs') {
          launchUrl($faqurl);
        } else if (this.text == 'Privacy Policy') {
          launchUrl($privacypolicyurl);
        } else if (this.text == 'Terms & Conditions') {
          launchUrl($termscondiitonsurl);
        } else if (this.text == 'Contact Us') {
          Navigator.of(context).push(
              MyFadeRoute(builder: (context) => ContactUsScreen())
          );
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
