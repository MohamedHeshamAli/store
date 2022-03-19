import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:my_store/pages/adding_order/screens/bill__details_screen.dart';
import 'package:my_store/pages/adding_order/widgets.dart';
import 'package:my_store/pages/login/widgets.dart';

import '../adding_order_control.dart';

class ProductsScreen extends StatelessWidget {
  var controller = Get.put(AddingOrderController());
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            decoration: InputDecoration(
                hintText: "البحث",
                prefixIcon: Icon(Icons.search),
                prefix: Icon(Icons.search)),
            onChanged: (val) {
              controller.productSearch(val);
            },
          ),
        ),
        bottomNavigationBar: MyButton(
          label: "تفاصيل الفاتوره",
          onTaP: () {
            Get.to(BillDetailsScreen());
          },
        ),
        body: GetX<AddingOrderController>(builder: (_) {
          return Column(
            children: [
              StepsUi(),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (ctx, n) {
                      return const SizedBox(
                        height: 1,
                      );
                    },
                    itemCount: controller.searched_products_list.length,
                    itemBuilder: (ctx, n) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                child: Center(
                                  child: Text(
                                    controller.searched_products_list.value[n]
                                            .price
                                            .toString() +
                                        "\nL.E",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                controller.searched_products_list.value[n]
                                    .product_name,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    AddProductDialog(
                                        ctx,
                                        controller,
                                        controller
                                            .searched_products_list.value[n]);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
