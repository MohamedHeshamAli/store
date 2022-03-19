import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_store/pages/login/login_screen.dart';
//

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.light(
          primary: Colors.orange,
        ),
      ),
      home: //TestUi()
          Directionality(
        textDirection: TextDirection.rtl,
        child: LogineScreen(),
      ),
    );
  }
}
