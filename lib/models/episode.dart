import 'package:daikhopk/screens/splash_screen.dart';

import '../constants.dart';

class Episode {
  int _episodeid;
  int _episodeno;
  String _episodetitle;
  String _episodeUrl;
  String _episodeVideoId;
  String _episodeThumbnail;

  Episode(this._episodeid, this._episodeno, this._episodetitle, this._episodeUrl);

  int get episodeid => _episodeid; // ignore: unnecessary_getters_setters
  set episodeid(int episodeid) =>_episodeid = episodeid; // ignore: unnecessary_getters_setters
  int get episodeno => _episodeno; // ignore: unnecessary_getters_setters
  set episodeno(int episodeno) =>_episodeno = episodeno; // ignore: unnecessary_getters_setters
  String get episodetitle => _episodetitle; // ignore: unnecessary_getters_setters
  set episodetitle(String episodetitle) => _episodetitle = episodetitle; // ignore: unnecessary_getters_setters
  String get episodeUrl => _episodeUrl; // ignore: unnecessary_getters_setters
  set episodeUrl(String episodeUrl) => _episodeUrl = episodeUrl; // ignore: unnecessary_getters_setters
  String get episodeVideoId => _episodeVideoId; // ignore: unnecessary_getters_setters
  set episodeVideoId(String episodeVideoId) => _episodeVideoId = episodeVideoId; // ignore: unnecessary_getters_setters
  String get episodeThumbnail => _episodeThumbnail; // ignore: unnecessary_getters_setters
  set episodeThumbnail(String episodeThumbnail) => _episodeThumbnail = episodeThumbnail; // ignore: unnecessary_getters_setters

  // named constructor
  Episode.fromJson(Map<String, dynamic> json, int showid) {
    _episodeid = json['episodeid'];
    _episodeno = json['episodeno'];
    _episodetitle = json['episodetitle'];
    _episodeUrl = json['episodeUrl'];
    _episodeVideoId = json['episodeVideoId'];
    _episodeThumbnail = json['episodeThumbnail'];
    if(isWeb) {
      _episodeThumbnail = $firebasestorageurl + 'daikhopk-imagedata%2F' + showid.toString() + '%2F' + _episodeno.toString() + '.jpg?alt=media&' + $firebasetoken;
      //https://firebasestorage.googleapis.com/v0/b/daikhopk-17b2f.appspot.com/o/daikhopk-imagedata%2F10001%2Fposter.jpg?alt=media&token=7bd07c88-fee4-45a2-bb18-5903490ffe6c
    } else {
      _episodeThumbnail = json['posterUrl'] ?? "";
    }
  }
}
