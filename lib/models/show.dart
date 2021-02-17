import 'package:daikhopk/models/season.dart';
import 'package:daikhopk/screens/splash_screen.dart';

import '../constants.dart';

class Show {
  int _showid;
  String _showname;
  String _showtype;
  String _posterUrl;
  String _trailerUrl;
  String _trailerVideoId;
  int _embed;
  String _channel;
  int _totalseasons;
  int _totalepisodes;
  int _completed;
  DateTime _releaseDatetime;
  DateTime _updateDatetime;
  int _viewCount;
  int _likeCount;
  Map<int, Season> _seasons;

  Show(this._showid, this._showname, this._showtype, this._posterUrl, this._trailerUrl, this._trailerVideoId, this._embed, this._channel, this._totalseasons, this._totalepisodes, this._completed, this._releaseDatetime, this._updateDatetime, this._viewCount, this._likeCount, this._seasons);

  int get showid => _showid; // ignore: unnecessary_getters_setters
  set showid(int showid) => _showid = showid; // ignore: unnecessary_getters_setters
  String get showname => _showname; // ignore: unnecessary_getters_setters
  set showname(String showname) => _showname = showname; // ignore: unnecessary_getters_setters
  String get showtype => _showtype; // ignore: unnecessary_getters_setters
  set showtype(String showtype) => _showtype = showtype; // ignore: unnecessary_getters_setters
  String get posterUrl => _posterUrl; // ignore: unnecessary_getters_setters
  set posterUrl(String posterUrl) => _posterUrl = posterUrl; // ignore: unnecessary_getters_setters
  String get channel => _channel; // ignore: unnecessary_getters_setters
  set channel(String channel) => _channel = channel; // ignore: unnecessary_getters_setters
  String get trailerUrl => _trailerUrl; // ignore: unnecessary_getters_setters
  set trailerUrl(String trailerUrl) => _trailerUrl = trailerUrl; // ignore: unnecessary_getters_setters
  String get trailerVideoId => _trailerVideoId; // ignore: unnecessary_getters_setters
  set trailerVideoId(String trailerVideoId) => _trailerVideoId = trailerVideoId; // ignore: unnecessary_getters_setters
  int get embed => _embed; // ignore: unnecessary_getters_setters
  set embed(int embed) => _embed = embed; // ignore: unnecessary_getters_setters
  int get totalseasons => _totalseasons; // ignore: unnecessary_getters_setters
  set totalseasons(int totalseasons) => _totalseasons = totalseasons;
  int get totalepisodes => _totalepisodes; // ignore: unnecessary_getters_setters
  set totalepisodes(int totalepisodes) => _totalepisodes = totalepisodes; // ignore: unnecessary_getters_setters
  int get completed => _completed; // ignore: unnecessary_getters_setters
  set completed(int completed) => _completed = completed; // ignore: unnecessary_getters_setters
  DateTime get releaseDatetime => _releaseDatetime; // ignore: unnecessary_getters_setters
  set releaseDatetime(DateTime releaseDatetime) => _releaseDatetime = releaseDatetime; // ignore: unnecessary_getters_setters
  DateTime get updateDatetime => _updateDatetime; // ignore: unnecessary_getters_setters
  set updateDatetime(DateTime updateDatetime) => _updateDatetime = updateDatetime; // ignore: unnecessary_getters_setters
  int get viewCount => _viewCount; // ignore: unnecessary_getters_setters
  set viewCount(int viewCount) => _viewCount = viewCount; // ignore: unnecessary_getters_setters
  int get likeCount => _likeCount; // ignore: unnecessary_getters_setters
  set likeCount(int likeCount) => _likeCount = likeCount; // ignore: unnecessary_getters_setters
  Map<int, Season> get seasons => _seasons; // ignore: unnecessary_getters_setters
  set seasons(Map<int, Season> seasons) => _seasons = seasons; // ignore: unnecessary_getters_setters

  // named constructor
  Show.fromJson(Map<String, dynamic> json) {
    _showid = json['showid']?? 0;
    _showname = json['showname']?? "";
    _showtype = json['showtype']?? "";
    if(isWeb) {
      _posterUrl = $firebasestorageurl + 'daikhopk-imagedata%2F' + _showid.toString() + '%2Fposter.jpg?alt=media&' + $firebasetoken;
      //https://firebasestorage.googleapis.com/v0/b/daikhopk-17b2f.appspot.com/o/daikhopk-imagedata%2F10001%2Fposter.jpg?alt=media&token=7bd07c88-fee4-45a2-bb18-5903490ffe6c
    } else {
      _posterUrl = json['posterUrl'] ?? "";
    }
    if(_posterUrl == "") {
      _posterUrl = $firebasestorageurl + 'daikhopk-imagedata%2F' + 'daikho_icon_blackbgsquare.png?alt=media&' + $firebasetoken;
    }
    _trailerVideoId = json['trailerVideoId']?? "";
    _trailerUrl = 'https://www.youtube.com/watch?v=' + _trailerVideoId?? "";
    _embed = json['embed']?? 0;
    _channel = json['channel']?? "";
    _totalseasons = json['totalseasons']?? 0;
    _totalepisodes = json['totalepisodes']?? 0;
    _completed = json['completed']?? 0;
    try {
      _releaseDatetime = DateTime.parse(json['releaseDatetime']?? "2021-01-01");
    } catch (e) {
      _releaseDatetime = DateTime.parse('2021-01-01');
    }
    try {
      _updateDatetime = DateTime.parse(json['updateDatetime']?? "2021-01-01");
    } catch (e) {
      _updateDatetime = DateTime.parse('2021-01-01');
    };
    _viewCount = json['viewCount']?? 0;
    _likeCount = json['likeCount']?? 0;
    if (json['seasons'] != null) {
      _seasons = new Map<int, Season>();
      json['seasons'].forEach((v) {
        _seasons.putIfAbsent(v['seasonno'], () => Season.fromJson(v, _showid));
      });
    }
  }
}