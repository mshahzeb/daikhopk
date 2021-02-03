import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/models/channel.dart';

class Shows {
  Map<int, Show> _shows;
  Map<String, Channel> _channels;
  List<int> _featured;

  Shows(this._shows, this._channels, this._featured);

  Map<int, Show> get shows => _shows;
  set shows(Map<int, Show> shows) => _shows = shows;
  Map<String, Channel> get channels => _channels;
  set channels(Map<String, Channel> channels) => _channels = channels;
  List<int> get featured => _featured;
  set featured(List<int> shows) => _featured = _featured;

  Shows.fromJson(Map<String, dynamic> json) {
    if (json['shows'] != null) {
      _shows = new Map<int, Show>();
      json['shows'].forEach((v) {
        _shows.putIfAbsent(v['showid'], () => Show.fromJson(v));
      });
    }
    if (json['channels'] != null) {
      _channels = new Map<String, Channel>();
      json['channels'].forEach((v) {
        _channels.putIfAbsent(v['channel'], () => Channel.fromJson(v));
      });
    }
    if (json['featured'] != null) {
      _featured = new List();
      json['featured'].forEach((v) {
        _featured.add(v['showid']);
      });
    }
  }

}