import 'package:daikhopk/models/show.dart';

class Shows {
  Map<int, Show> _shows;

  Shows(this._shows);

  Map<int, Show> get shows => _shows;
  set shows(Map<int, Show> shows) => _shows = shows;

  Shows.fromJson(Map<String, dynamic> json) {
    if (json['shows'] != null) {
      _shows = new Map<int, Show>();
      json['shows'].forEach((v) {
        _shows.putIfAbsent(v['showid'], () => Show.fromJson(v));
      });
    }
  }

}