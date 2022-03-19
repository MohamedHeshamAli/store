import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_store/pages/adding_order/adding_order_control.dart';
import 'package:my_store/pages/adding_order/widgets.dart';
import 'package:my_store/pages/login/widgets.dart';

class BillDetailsScreen extends StatelessWidget {
  var controller = Get.put(AddingOrderController());
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: GetX<AddingOrderController>(initState: (_) {
            controller.initBillValue();
          }, builder: (_) {
            return Center(
              child: Text(
                  "قيمه الفاتوره: ${controller.bill_total_value.value.toStringAsFixed(2)}"),
            );
          }),
        ),
        bottomNavigationBar: MyButton(
          borderRaduis: 0,
          noMargin: true,
          color: Colors.green,
          label: "حفظ التعديلات",
          onTaP: () {
            controller.saveBillChanges();
            Get.back();
          },
        ),
        body: GetBuilder<AddingOrderController>(
          initState: (_) {
            controller.setBillList();
          },
          builder: (cnt) {
            return ListView.builder(
              itemBuilder: (ctx, n) {
                return Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                          controller.bill_details_list.value[n].product_name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        BillDetailsWidget(
                          product: controller.bill_details_list.value[n],
                        ),
                        MyButton(
                          noMargin: true,
                          borderRaduis: 0,
                          color: Colors.red,
                          label: "حذف",
                          onTaP: () {
                            controller.removeItemfromBill(n);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.bill_details_list.value.length,
            );
          },
        ),
      ),
    );
  }
}
