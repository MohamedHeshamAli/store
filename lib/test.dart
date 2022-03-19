import 'package:mysql1/mysql1.dart';

// class p {
//   String name = "m0";
//   int val = 5;
// }

void main() async {
  try {
    var settings = ConnectionSettings(
        host: 'localhost', port: 3306, user: 'root', db: 'sales_projectv1');
    var conn = await MySqlConnection.connect(settings);
    var results = await conn.query(
        'select * from useres where username =? and pass =?', ["a", "a"]);

    var stores = await conn.query('select * from stores');
    var moneys = await conn.query('select * from money');
    var clients = await conn.query('select * from client');

    // print(results.runtimeType);
    // print(results.fields[0]);
    // print(results.first.values);
    // print(results.first.fields);
    // print(results);
    //print(stores.first.fields["name"].runtimeType);
    moneys.forEach((element) {
      print(element.fields["money"]);
      print(element.fields["money"].runtimeType);
    });

    //(conn.runtimeType);
    await conn.close();
  } catch (e) {
    print(e);
  }
}
