import 'package:flutter/material.dart';

const int $middot = 0x00B7;
final double $defaultWidth = 125;
final double $defaultHeight = 75;

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

//Default Values
final String $logopath = 'assets/logo/daikho_logo.png';
final String $iconpath = 'assets/logo/daikho_icon.png';
final String $iconcirclepath = 'assets/logo/daikho_icon_blackbgcircle.png';
final String $iconovalpath = 'assets/logo/daikho_icon_blackbgoval.png';
final int $shownamescode = 100;
final int $maxtrycounthttp = 2;
final String $nodata = "0\n";
final int $maxfeatured = 5;

//Circular Progress CircularProgressIndicator
final Color $circularbackgroundcolor = Colors.black;
final Color $circularstrokecolor = Colors.redAccent;
final double $circularstrokewidth = 5;

//General Info
final String $aboutus = '''
daikho.pk is a free content delivery platform focused primarily on Pakistani television content. It is the largest collection of Pakistani TV Serials & TV Series.
\nOur platform links & hosts content that is available to watch freely on platforms like YouTube, Daily Motion and does not own any of the content. All rights are reserved with the content providers. We comply with all the Terms & Services of the platform’s videos embedding policies. All views of the videos on our platform are attributed to the content owners on their respective platforms.
''';
final String $faqurl = 'https://daikho.pk';
final String $privacypolicyurl = 'https://daikho.pk';
final String $supportemail = 'pk.daikho@gmail.com';