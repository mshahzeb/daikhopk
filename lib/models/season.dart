import 'episode.dart';

class Season {
  int _seasonno = 0;
  Map<int, Episode> _episodes = Map();

  Season();

  int get seasonno => _seasonno; // ignore: unnecessary_getters_setters
  set seasonno(int seasonno) => _seasonno = seasonno; // ignore: unnecessary_getters_setters
  Map<int, Episode> get episodes => _episodes; // ignore: unnecessary_getters_setters
  set episodes(Map<int, Episode> episodes) => _episodes = episodes; // ignore: unnecessary_getters_setters

  // named constructor
  Season.fromJson(Map<String, dynamic> json, int showid) {
    _seasonno = json['showid']?? 0;
    if (json['episodes'] != null) {
      _episodes = new Map<int, Episode>();
      json['episodes'].forEach((v) {
        _episodes.putIfAbsent(v['episodeno'], () => Episode.fromJson(v, showid));
      });
    }
  }
}