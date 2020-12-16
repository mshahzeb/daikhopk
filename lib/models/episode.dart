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
  Episode.fromJson(Map<String, dynamic> json)
      : _episodeid = json['episodeid'],
        _episodeno = json['episodeno'],
        _episodetitle = json['episodetitle'],
        _episodeUrl = json['episodeUrl'],
        _episodeVideoId = json['episodeVideoId'],
        _episodeThumbnail = json['episodeThumbnail'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'episodeid': _episodeid,
      'episodeno': _episodeno,
      'episodetitle': _episodetitle,
      'episodeUrl': _episodeUrl,
      'episodeVideoId': _episodeVideoId,
      'episodeThumbnail': _episodeThumbnail
    };
  }

}