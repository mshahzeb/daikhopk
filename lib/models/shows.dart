import 'package:daikhopk/models/show.dart';

class Shows {
  List<Show> _shows;

  Shows(this._shows);

  List<Show> get shows => _shows;
  set shows(List<Show> shows) => _shows = shows;

  Shows.fromJson(Map<String, dynamic> json) {
    if (json['shows'] != null) {
      _shows = new List<Show>();
      json['shows'].forEach((v) {
        _shows.add(new Show.fromJson(v));
      });
    }
  }

}