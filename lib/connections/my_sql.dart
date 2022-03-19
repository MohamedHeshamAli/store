import 'package:my_store/constants.dart';
import 'package:mysql1/mysql1.dart';

import '../pages/adding_order/product.dart';

class MySql {
  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: '10.0.2.2', port: 3306, user: 'root', db: 'sales_projectv1');
    var conn = await MySqlConnection.connect(settings);
    return conn;
  }

  Future<bool> checkLogin(String userName, String pass) async {
    bool connected;

    try {
      mySqlConnection = await getConnection();

      var results = await mySqlConnection!.query(
          'select username , id from useres where username =? and pass =?',
          [userName, pass]);
      if (results.isNotEmpty) {
        connected = true;
        user_name = results.first.values![0].toString();
        user_id = results.first.values![1].toString();
        await setBasicInfo();
      } else
        connected = false;
    } catch (e) {
      print("error login");
      connected = false;
    }
    return connected;
  }

  Future<List<List<String>>> getTreasuryes() async {
    var results = await mySqlConnection!.query('select * from money');
    List<String> money_name_list = [];
    List<String> money_id_list = [];
    results.forEach((element) {
      money_name_list.add(element.fields["name"].toString());
      money_id_list.add(element.fields["id"].toString());
    });
    return [money_name_list, money_id_list];
  }

  Future getstores() async {
    var results = await mySqlConnection!.query('select name , id from stores');
    List<String> stores_name_list = [];
    List<String> stores_id_list = [];
    results.forEach((element) {
      stores_name_list.add(element.fields["name"].toString());
      stores_id_list.add(element.fields["id"].toString());
    });
    return {"name": stores_name_list, "id": stores_id_list};
  }

  Future getStoresProduct() async {
    Map<String, List<String>> stores = await getstores();
    Map<String, List<Product>> products = {};
    var results =
        await mySqlConnection!.query('select * from product order by id');

    String id = results.first.fields["id_of_story"].toString();
    List<Product> product_list = [];
    results.forEach((element) {
      if (id == element.fields["id_of_story"].toString()) {
        var fields = element.fields;

        product_list.add(Product(
            id: fields["id"].toString(),
            product_name: fields["name"].toString(),
            count_in_store: fields["quan"].round(),
            buy_price: double.parse(fields["buyPrice"].toString()),
            price: double.parse(fields["sal1"].toString())));
      } else {
        String store_name = stores["name"]![stores["id"]!.indexOf(id)];
        products[store_name] = product_list;
        id = element.fields["id_of_story"];
        product_list = [];
      }
    });
    String store_name = stores["name"]![stores["id"]!.indexOf(id)];

    products[store_name] = product_list;

    return products;
  }

  Future getClients() async {
    var results = await mySqlConnection!.query('select * from client');
    List<String> client_name_list = [];
    List<String> client_id_list = [];
    results.forEach((element) {
      client_name_list.add(element.fields["name"].toString());
      client_id_list.add(element.fields["id"].toString());
    });
    return {"name": client_name_list, "id": client_id_list};
  }

  Future setBasicInfo() async {
    var results = await mySqlConnection!.query('select * from basicinfo');
    whats = results.first.fields["whatsapp"];
    facebook = results.first.fields["facebook"];
    instagram = results.first.fields["instagram"];
  }

  Future getNextInvoNum() async {
    var results =
        (await mySqlConnection!.query('select max(invo) from order_master'));
    if (results.first.values![0] == null || results.first.values!.isEmpty)
      return 1;
    else {
      int invo = (results.first.values![0]) as int;
      return invo + 1;
    }
  }

  Future insertOrderDetails({
    required invo,
    required id,
    required name,
    required quan,
    required price,
    required tottal,
    required reb7,
  }) async {
    try {
      var result = await mySqlConnection!.query(
        "insert into order_deatils (invo,id,name,quan,price,tottal,reb7)"
        "values (?,?,?,?,?,?,?)",
        [invo, id, name, quan, price, tottal, reb7],
      );
    } catch (e) {
      print("error in order details");
      print(e);
    }
  }

  Future insertOrderMaster(
      {required invo,
      required value,
      required khasm,
      required id_of_client,
      required id_of_user,
      required name_of_user,
      required id_of_story,
      required name_of_story,
      required id_of_money,
      required name_of_money,
      required status,
      required type,
      required reb7,
      required date,
      required time,
      required status_halk,
      required type_halk,
      required nameOfClient}) async {
    try {
      var result = await mySqlConnection!.query(
          "insert into order_master (invo,value,khasm,id_of_client,id_of_user, name_of_user,id_of_story,name_of_story,id_of_money,name_of_money, status,type,reb7,date,time,status_halk, type_halk,nameOfClient) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            invo,
            value,
            khasm,
            id_of_client,
            id_of_user,
            name_of_user,
            id_of_story,
            name_of_story,
            id_of_money,
            name_of_money,
            status,
            type,
            reb7,
            date,
            time,
            status_halk,
            type_halk,
            nameOfClient
          ]);
    } catch (e) {
      print("error in order master");
      print(e);
    }
  }
}
