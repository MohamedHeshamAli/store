import 'package:flutter/cupertino.dart';
import 'package:my_store/connections/my_sql.dart';
import 'package:mysql1/mysql1.dart';

const TextStyle title_style = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);
MySqlConnection? mySqlConnection;
MySql? mySql;
String? user_name;
String? user_id;
String whats = "01151394540";
String facebook = "";
String instagram = "";
