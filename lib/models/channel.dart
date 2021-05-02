class Channel {
  String _channelid = '';
  String _channel = '';
  String _logoUrl = '';
  int _shows = 0;

  Channel();

  String get channelid => _channelid; // ignore: unnecessary_getters_setters
  set channelid(String channelid) => _channelid = channelid; // ignore: unnecessary_getters_setters
  String get channel => _channel; // ignore: unnecessary_getters_setters
  set channel(String channel) => _channel = channel; // ignore: unnecessary_getters_setters
  String get logoUrl => _logoUrl; // ignore: unnecessary_getters_setters
  set logoUrl(String logoUrl) => _logoUrl = logoUrl; // ignore: unnecessary_getters_setters
  int get shows => _shows; // ignore: unnecessary_getters_setters
  set shows(int logoUrl) => _shows = shows; // ignore: unnecessary_getters_setters

  // named constructor
  Channel.fromJson(Map<String, dynamic> json) {
    _channelid = json['channelid'] ?? "";
    _channel = json['channel'] ?? "";
    _logoUrl = json['logoUrl'] ?? "";
    _shows = json['shows'] ?? "";
  }
}