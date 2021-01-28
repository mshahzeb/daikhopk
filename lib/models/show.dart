import 'package:daikhopk/models/season.dart';

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
  int _releaseYear;
  int _viewCount;
  Map<int, Season> _seasons;

  Show(this._showid, this._showname, this._showtype, this._posterUrl, this._trailerUrl, this._trailerVideoId, this._embed, this._channel, this._totalseasons, this._totalepisodes, this._completed, this._releaseYear, this._viewCount, this._seasons);

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
  int get releaseYear => _releaseYear; // ignore: unnecessary_getters_setters
  set releaseYear(int releaseYear) => _releaseYear = releaseYear; // ignore: unnecessary_getters_setters
  int get viewCount => _viewCount; // ignore: unnecessary_getters_setters
  set viewCount(int viewCount) => _viewCount = viewCount; // ignore: unnecessary_getters_setters
  Map<int, Season> get seasons => _seasons; // ignore: unnecessary_getters_setters
  set seasons(Map<int, Season> seasons) => _seasons = seasons; // ignore: unnecessary_getters_setters

  // named constructor
  Show.fromJson(Map<String, dynamic> json) {
    _showid = json['showid'];
    _showname = json['showname'];
    _showtype = json['showtype'];
    _posterUrl = json['posterUrl'];
    _trailerUrl = json['trailerUrl'];
    _trailerUrl = json['trailerVideoId'];
    _embed = json['embed'];
    _channel = json['channel'];
    _totalseasons = json['totalseasons'];
    _totalepisodes = json['totalepisodes'];
    _completed = json['completed'];
    _releaseYear = json['releaseYear'];
    _viewCount = json['viewCount'];
    if (json['seasons'] != null) {
      _seasons = new Map<int, Season>();
      json['seasons'].forEach((v) {
        _seasons.putIfAbsent(v['seasonno'], () => Season.fromJson(v));
      });
    }
  }
}