import 'dart:collection';

import 'package:flutter/material.dart';

// Const numbers
const int $middot = 0x00B7;
final double $defaultWidth = 125;
final double $defaultHeight = 75;
final int $maxtiles = 20;
final double $webbuttonspadding = 250.00;

// Web Service Configs
final String $serverName = 'daikho.pk';
final String $apiKey = "mZAR8w9KJ5Kbz2S7aFuT2KtneqTmC5zZ";

final String $serverPortshowapi = '5002';
final String $serviceURLshowapi = 'https://' + $serverName + ':' + $serverPortshowapi + '/' + $apiKey;

final String $serverPortusrapi = '5012';
final String $serviceURLusrapi = 'https://' + $serverName + ':' + $serverPortusrapi + '/' + $apiKey;

final String $serviceURLversion = $serviceURLshowapi + '/showdata';
final String $serviceURLshowdata = $serviceURLshowapi + '/showdata/data';
final String $serviceURLupdateuserinfo = $serviceURLusrapi + '/updateuserinfo';
final String $serviceURLupdatestats = $serviceURLusrapi + '/updatestat';
final String $serviceURLgetstats = $serviceURLusrapi + '/getstat';
final String $serviceURLcontact = $serviceURLusrapi + '/contact';

//Default Values
final String $logopath = 'assets/logo/daikho_logo.png';
final String $iconpath = 'assets/logo/daikho_icon.png';
final String $problempath = 'assets/images/problem.png';
final String $iconcirclepath = 'assets/logo/daikho_icon_blackbgcircle.png';
final String $iconovalpath = 'assets/logo/daikho_icon_blackbgoval.png';
final int $shownamescode = 100;
final int $maxtrycounthttp = 2;
final String $nodata = "0\n";
final int $maxfeatured = 5;

final String $defaultprofilepicture = "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png";

//Circular Progress CircularProgressIndicator
final Color $circularbackgroundcolor = Colors.black;
final Color $circularstrokecolor = Colors.redAccent;
final double $circularstrokewidth = 5;

//General Info
final String $aboutus = '''
daikho.pk is a free content delivery platform focused primarily on Pakistani television content. It is the largest collection of Pakistani TV Serials & TV Series.
\nOur platform only links the content that is available to watch freely on public platforms on the internet and does not own any of the content. All rights are reserved with the content owners. We comply with all the Terms & Services of the respective platform’s videos embedding policies. All views of the videos on our platform are attributed to the content owners on their respective platforms.
''';

final String $disclaimer = '''
daikho.pk is a free content delivery platform focused primarily on Pakistani television content. It is the largest collection of Pakistani TV Serials & TV Series.
\nOur platform only links the content that is available to watch freely on public platforms on the internet and does not own any of the content. All rights are reserved with the content owners. We comply with all the Terms & Services of the respective platform’s videos embedding policies. All views of the videos on our platform are attributed to the content owners on their respective platforms.
''';

final String $features = '''
By signing in you get!

 - Save your Watching History
 - Continue from where you left off
 - Personalized Recommendations
 - Get all your recently watched shows in one place
''';

final String $faqurl = 'https://daikho.pk/#FAQs';
final String $privacypolicyurl = 'https://daikho.pk/privacy-policy/';
final String $termscondiitonsurl = 'https://daikho.pk/terms-conditions/';
final String $facebookurl = 'https://facebook.com/daikho.pk';
final String $supportemail = 'support@daikho.pk';

//FIrebase Storage
final String $firebasestorageurl = 'https://firebasestorage.googleapis.com/v0/b/daikhopk-17b2f.appspot.com/o/';
final String $firebasetoken  = 'token=7bd07c88-fee4-45a2-bb18-5903490ffe6c';

//Links
final String $playstorelink = 'https://bit.ly/3duX8H2';
final String $appstorelink = '';