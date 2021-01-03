import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/models/channel.dart';

class Shows {
  Map<int, Show> _shows;
  Map<String, Channel> _channels;

  Shows(this._shows, this._channels);

  Map<int, Show> get shows => _shows;
  set shows(Map<int, Show> shows) => _shows = shows;
  Map<String, Channel> get channels => _channels;
  set channels(Map<String, Channel> channels) => _channels = channels;

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
  }

}