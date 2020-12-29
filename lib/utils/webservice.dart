import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

Future<Response> fetchUrl(final String url) async {
  Response response;
  int trycount = 0;

  while (trycount < $maxtrycounthttp) {
    try {
      response = await get(Uri.encodeFull(url), headers: {"Accept":"application/json", "Connection":"keep-alive"});
      if (response.statusCode == 200) {
        return response;
      } else {
        trycount++;
      }
    } on SocketException {
      print('No Internet connection');
      trycount++;
    } on HttpException {
      print("Couldn't find the post");
      trycount++;
    } on FormatException {
      print("Bad response format");
      trycount++;
    }
  }
  throw Exception('Failed to load post');
}

Future<String> fetchUrlCached(final int id) async {
  Response response;
  String versionuuid;
  String jsonversion;
  String jsonstring;

  String jsonversion_key;
  String jsonstring_key;

  response = await fetchUrl($serviceURLversion + "/" + id.toString());
  versionuuid = jsonDecode(response.body)['version'];

  jsonversion_key = id.toString() + "_version";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  jsonversion = prefs.getString(jsonversion_key);
  jsonstring_key = id.toString() + "_jsontring";

  if(jsonversion != versionuuid) {
    response = await fetchUrl($serviceURLshowdata + "/" + id.toString());
    jsonstring = response.body;

    prefs.setString(jsonversion_key, versionuuid);
    prefs.setString(jsonstring_key, jsonstring);
  } else {
    jsonstring = prefs.getString(jsonstring_key);
  }

  return jsonstring;
}

Future<String> postUrl(final String url, final Map<String, dynamic> Json) async {
  Response response;
  int trycount = 0;

  while (trycount < $maxtrycounthttp) {
    try {
      response = await post(Uri.encodeFull(url), headers: {"Content-Type":"application/json", "Connection":"keep-alive"}, body: jsonEncode(Json));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        trycount++;
      }
    } on SocketException {
      print('No Internet connection');
      trycount++;
    } on HttpException {
      print("Couldn't find the post");
      trycount++;
    } on FormatException {
      print("Bad response format");
      trycount++;
    }
  }
  throw Exception('Failed to Post');
}