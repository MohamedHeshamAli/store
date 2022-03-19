import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_store/pages/adding_order/screens/add_order_screen.dart';
import 'package:my_store/pages/home/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("متجري"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                HomeCard(
                  onTap: () {
                    Get.to(AddingOrderScreen());
                  },
                  icon: Icons.shopping_cart,
                  label: "اضافة اوردر",
                ),
              ],
            ),
          ),
        ));
  }
}
