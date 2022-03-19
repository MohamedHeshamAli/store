import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_store/pages/adding_order/adding_order_control.dart';
import 'package:my_store/pages/adding_order/widgets.dart';
import 'package:my_store/pages/login/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class TableScreen extends StatelessWidget {
  var controller = Get.put(AddingOrderController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          bottomNavigationBar: MyButton(
            label: "طباعه",
            onTaP: () async {
              var controller = ScreenshotController();

              Uint8List bytes = await controller.captureFromWidget(Material(
                child: BillTables(),
              ));

              //Image image = Image.memory(bytes);
              final temp = await getTemporaryDirectory();
              final path = "${temp.path}/image.jpg";
              File(path).writeAsBytes(bytes);
              await Share.shareFiles([path]);
            },
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("الفاتوره"),
          ),
          body: BillTables(),
        ));
  }
}
