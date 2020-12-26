const int $middot = 0x00B7;
final double $defaultWidth = 150;

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

final int $shownamescode = 100;
final int $showfeaturedcode = 100;

final int $maxtrycounthttp = 2;

final String $logopath = 'assets/logo/daikho_logo.png';