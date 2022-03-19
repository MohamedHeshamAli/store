import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_store/pages/adding_order/adding_order_control.dart';
import 'package:my_store/pages/adding_order/product.dart';
import 'package:my_store/pages/adding_order/screens/table_screen.dart';
import 'package:my_store/pages/adding_order/widgets.dart';
import 'package:my_store/pages/login/widgets.dart';

class AddingOrderScreen extends StatelessWidget {
  TextEditingController customer_name_controller = TextEditingController();
  TextEditingController customer_code_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController(
      text:
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
  var controller = Get.put(AddingOrderController());
  TextEditingController rebate_controller =
      TextEditingController(text: Product.rebate.toString());
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          bottomNavigationBar: MyButton(
            label: "حفظ",
            color: Colors.green,
            onTaP: () async {
              bool isSaved = await controller.save();
              if (isSaved)
                Get.to(TableScreen())!.then((value) => controller.clearOrder());
              else
                showErrorDialog(context);
            },
          ),
          appBar: AppBar(
            title: const Center(child: Text("اضافة اوردر")),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                StepsUi(),
                const SizedBox(
                  height: 10,
                ),
                MyTextfield(
                  validator: (str) {},
                  controller: date_controller,
                  hint: "التاريخ",
                  icon: Icons.calendar_today,
                  isReadOnly: true,
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 36500)),
                            lastDate: DateTime.now().add(Duration(days: 36500)))
                        .then((value) {
                      if (value != null) {
                        date_controller.text =
                            "${value.year}-${value.month}-${value.day}";
                        controller.changeDate(date_controller.text);
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GetX<AddingOrderController>(
                  builder: (_) {
                    return Column(
                      children: [
                        MyDropDownButton(
                            valuesList: controller.client_name_list.value,
                            label: "اسم العميل : ",
                            initVal: controller.client_name.value,
                            onchage: (val) {
                              controller.changeClientName(val);
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        MyDropDownButton(
                            valuesList: controller.client_id_list.value,
                            label: "كود العميل : ",
                            initVal: controller.client_id.value,
                            onchage: (val) {
                              controller.changeClientId(val);
                            }),
                      ],
                    );
                  },
                ),
                GetX<AddingOrderController>(
                  builder: (_) {
                    return Column(
                      children: [
                        MyDropDownButton(
                            valuesList: controller.money_list.value,
                            label: "اسم الخزينه ",
                            initVal: controller.money_name.value,
                            onchage: (val) {
                              controller.changeMoney(val);
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        MyDropDownButton(
                            valuesList: controller.stores_name_list.value,
                            label: "اسم المخزن ",
                            initVal: controller.store_name.value,
                            onchage: (val) {
                              controller.changeStore(val);
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        MyDropDownButton(
                            valuesList: controller.selling_type_list.value,
                            label: "نوع البيع ",
                            initVal: controller.current_selling_type.value,
                            onchage: (val) {
                              controller.changeSellingType(val);
                            }),
                      ],
                    );
                  },
                ),
                MyTextfield(
                  keyboardType: TextInputType.number,
                  validator: (val) {},
                  controller: rebate_controller,
                  hint: "الخصم",
                  OnChanged: (val) {
                    if (val.isNotEmpty)
                      try {
                        double rebate = double.parse(val);
                        if (rebate > -1 && rebate < 100) {
                          double old_rebate = Product.rebate;

                          Product.rebate = rebate;
                          controller.updateRebate(old_rebate, rebate);
                        } else
                          rebate_controller.text = Product.rebate.toString();
                      } catch (e) {
                        rebate_controller.text = Product.rebate.toString();
                      }
                    else {
                      double old_rebate = Product.rebate;

                      Product.rebate = 0;
                      controller.updateRebate(old_rebate, Product.rebate);
                    }
                  },
                ),
                GetX<AddingOrderController>(
                  builder: (_) {
                    if (controller.isLoading.value) {
                      return CircularProgressIndicator();
                    } else
                      return Container();
                  },
                )
              ],
            ),
          )),
    );
  }
}
