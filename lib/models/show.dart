import 'episode.dart';

class Show {
  int _showid;
  String _showname;
  String _showtype;
  String _posterUrl;
  String _trailerUrl;
  String _trailerVideoId;
  int _embed;
  String _channel;
  int _completed;
  List<Episode> _episodes;

  Show(this._showid, this._showname, this._showtype, this._posterUrl, this._trailerUrl, this._embed, this._channel, this._episodes);

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
  List<Episode> get episodes => _episodes; // ignore: unnecessary_getters_setters
  set episodes(List<Episode> episodes) => _episodes = episodes; // ignore: unnecessary_getters_setters
  int get completed => _completed; // ignore: unnecessary_getters_setters
  set completed(int completed) => _completed = completed; // ignore: unnecessary_getters_setters

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
    _completed = json['completed'];
    if (json['episodes'] != null) {
      _episodes = new List<Episode>();
      json['episodes'].forEach((v) {
        _episodes.add(new Episode.fromJson(v));
      });
    }
  }

  // method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['showid'] = _showid;
    data['showname'] = _showname;
    data['showtype'] = _showtype;
    data['posterUrl'] = _posterUrl;
    data['trailerUrl'] = _trailerUrl;
    data['trailerVideoId'] = _trailerVideoId;
    data['embed'] = _embed;
    data['channel'] = _channel;
    data['completed'] = _completed;
    if (this._episodes != null) {
    data['episodes'] = this._episodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}