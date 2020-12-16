import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import '../constants.dart';

Rethinkdb r = Rethinkdb();
var connection;

Future<void> rethinkdb_connect() async {
  connection = await r.connect(db: $rethinkdb, host: $rethinkdbhost, port: $rethinkdbport, user: $rethinkdbuser, password: $rethinkdbpassword);
}

Future<void> rethinkdb_insert(String table, Map <String, String> query) async {
  await rethinkdb_connect();
  await r.table(table).insert(query).run(connection);
  connection.close(true);
}

Future<List> rethinkdb_get(String table, String id) async {
  await rethinkdb_connect();

  Cursor c = await r.table(table).get(id).run(connection);
  List rows = await c.toList();

  connection.close(true);

  return rows;
}