import 'package:daikhopk/utils/webservice.dart';
import 'package:daikhopk/constants.dart';
import 'package:http/http.dart';

Future<dynamic> getStat(final String uid, final String sid, final String stat) async {
  Map <String, dynamic> Json = {
    "uid": uid,
    "stat": stat,
    "sid": sid
  };

  Response result = await postUrl($serviceURLgetvideoidstats, Json);
  return result.body;
}

Future<void> updateStat(final String uid, final String sid, final List<String> stat, final List<dynamic> val) async {
  Map <String, dynamic> Json;
  for( int i = 0; i < stat.length; i++) {
    Json = {
      "uid": uid,
      "sid": sid,
      "stat": stat[i],
      "val": val[i]
    };
    postUrl($serviceURLupdatevideoidstats, Json);
  }
}