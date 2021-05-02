import 'package:daikhopk/models/show.dart';
import 'package:daikhopk/models/channel.dart';
import 'package:daikhopk/models/livechannel.dart';

class Shows {
  Map<int, Show> _shows = Map();
  Map<String, Channel> _channels = Map();
  Map<String, LiveChannel> _livechannels = Map();
  List<int> _featured = [];

  Shows();

  Map<int, Show> get shows => _shows;
  set shows(Map<int, Show> shows) => _shows = shows;
  Map<String, Channel> get channels => _channels;
  set channels(Map<String, Channel> channels) => _channels = channels;
  Map<String, LiveChannel> get livechannels => _livechannels;
  set livechannels(Map<String, LiveChannel> livechannels) => _livechannels = livechannels;
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
    if (json['livechannels'] != null) {
      _livechannels = new Map<String, LiveChannel>();
      json['livechannels'].forEach((v) {
        _livechannels.putIfAbsent(v['channel'], () => LiveChannel.fromJson(v));
      });
    }
    if (json['featured'] != null) {
      _featured = [];
      json['featured'].forEach((v) {
        _featured.add(v['showid']);
      });
    }
  }

}