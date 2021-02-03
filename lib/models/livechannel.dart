class LiveChannel {
  String _channelid;
  String _channel;
  String _logoUrl;
  String _videoId;

  LiveChannel(this._channelid, this._channel, this._logoUrl);

  String get channelid => _channelid; // ignore: unnecessary_getters_setters
  set channelid(String channelid) => _channelid = channelid; // ignore: unnecessary_getters_setters
  String get channel => _channel; // ignore: unnecessary_getters_setters
  set channel(String channel) => _channel = channel; // ignore: unnecessary_getters_setters
  String get logoUrl => _logoUrl; // ignore: unnecessary_getters_setters
  set logoUrl(String logoUrl) => _logoUrl = logoUrl; // ignore: unnecessary_getters_setters
  String get videoId => _videoId; // ignore: unnecessary_getters_setters
  set videoId(String videoId) => _videoId = videoId; // ignore: unnecessary_getters_setters

  // named constructor
  LiveChannel.fromJson(Map<String, dynamic> json) {
    _channelid = json['channelid'] ?? "";
    _channel = json['channel'] ?? "";
    _logoUrl = json['logoUrl'] ?? "";
    _videoId = json['videoId'] ?? "";
  }
}