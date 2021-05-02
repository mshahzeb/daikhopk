import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(String _Url) async {
  if (_Url.isNotEmpty) {
    if (await canLaunch(_Url)) {
      final bool _nativeAppLaunchSucceeded = await launch(
        _Url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!_nativeAppLaunchSucceeded) {
        await launch(_Url, forceSafariVC: true);
      }
    }
  }
}