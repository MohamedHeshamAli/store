import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_store/constants.dart';
import 'package:my_store/pages/adding_order/product.dart';
import 'package:my_store/pages/adding_order/screens/add_order_screen.dart';
import 'package:my_store/pages/adding_order/screens/products_screen.dart';
import 'package:my_store/pages/login/widgets.dart';

import 'adding_order_control.dart';

class StepsUi extends StatelessWidget {
  var controller = Get.put(AddingOrderController());
  @override
  Widget build(BuildContext context) {
    return GetX<AddingOrderController>(
      builder: (_) {
        return Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const CircleAvatar(
              radius: 13,
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
              child: Text(
                "1",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {
                controller.changeScreen(goToClientScreen: true);
                Get.off(AddingOrderScreen());
              },
              child: Text(
                "العميل",
                style: TextStyle(
                    fontSize: 18,
                    color: controller.is_client_screen.value
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 2,
                color: Colors.orange,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const CircleAvatar(
              radius: 13,
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
              child: Text(
                "2",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {
                controller.changeScreen(goToClientScreen: false);
                Get.off(ProductsScreen());
              },
              child: Text(
                "المنتجات",
                style: TextStyle(
                    fontSize: 18,
                    color: !controller.is_client_screen.value
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        );
      },
    );
  }
}

///////////////////////////////////////////////
//////////////drop down button////////////////
/////////////////////////////////////////////
class MyDropDownButton extends StatelessWidget {
  String initVal;
  List<String> valuesList;
  Function onchage;
  String label;
  MyDropDownButton({
    required this.valuesList,
    required this.label,
    required this.initVal,
    required this.onchage,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 2))
      ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "$label : ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
          ),
          DropdownButton<String>(
            value: initVal,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            onChanged: (newValue) {
              onchage(newValue);
            },
            items: valuesList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////
/////////////add product dialog///////////////
///////////////////////////////////////////////
AddProductDialog(
  BuildContext ctx,
  AddingOrderController controller,
  Product product,
) {
  Product new_product = Product(
    buy_price: product.buy_price,
    id: product.id,
    count_in_store: product.count_in_store,
    price: product.price,
    product_name: product.product_name,
  );

  TextEditingController price_controller =
      TextEditingController(text: new_product.price.toString());
  TextEditingController rebate_controller =
      TextEditingController(text: Product.rebate.toString());
  TextEditingController count_controller =
      TextEditingController(text: new_product.sell_count.toString());
  TextEditingController total_controller =
      TextEditingController(text: new_product.getTotalPrice().toString());

  showDialog(
      context: ctx,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Center(
                  child: Text(new_product.product_name,
                      style: TextStyle(color: Theme.of(ctx).primaryColor))),
              content: BillDetailsWidget(
                product: new_product,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    controller.order_list.value.add(new_product);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "اضافة",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "الغاء",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

////////////////////////////////////////////////
/////////////////bill details//////////////////
//////////////////////////////////////////////
class BillDetailsWidget extends StatelessWidget {
  var controller = Get.put(AddingOrderController());
  final Product product;
  BillDetailsWidget({required this.product});
  @override
  Widget build(BuildContext context) {
    TextEditingController price_controller =
        TextEditingController(text: product.new_price.toString());
    TextEditingController rebate_controller =
        TextEditingController(text: Product.rebate.toString());
    TextEditingController count_controller =
        TextEditingController(text: product.sell_count.toString());
    TextEditingController total_controller =
        TextEditingController(text: product.getTotalPrice().toString());

    return Column(
      children: [
        MyTextfield(
          keyboardType: TextInputType.number,
          validator: (val) {},
          controller: price_controller,
          hint: "السعر",
          OnChanged: (val) {
            if (val.isNotEmpty)
              try {
                double price = double.parse(val);
                if (price > -1) {
                  controller.updateBillTotalVal(product.getTotalPrice(), price);
                  product.newPrice = price;
                } else
                  price_controller.text = product.new_price.toString();
              } catch (e) {
                price_controller.text = product.new_price.toString();
              }
            else {
              controller.updateBillTotalVal(product.getTotalPrice(), 0.0);
              product.newPrice = 0.0;
            }
            total_controller.text = product.getTotalPrice().toString();
          },
        ),
        const SizedBox(
          height: 5,
        ),
        MyTextfield(
          keyboardType: TextInputType.number,
          validator: (val) {},
          controller: rebate_controller,
          isReadOnly: true,
          hint: "الخصم",
          OnChanged: (val) {
            if (val.isNotEmpty)
              try {
                double rebate = double.parse(val);
                if (rebate > -1 && rebate < 100) {
                  double old_price = product.getTotalPrice();

                  Product.rebate = rebate;
                  controller.updateBillTotalVal(
                      old_price, product.getTotalPrice());
                } else
                  rebate_controller.text = Product.rebate.toString();
              } catch (e) {
                rebate_controller.text = Product.rebate.toString();
              }
            else {
              double old_price = product.getTotalPrice();

              Product.rebate = 0;
              controller.updateBillTotalVal(old_price, product.getTotalPrice());
            }
            total_controller.text = product.getTotalPrice().toString();
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Text("العدد"),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  if (count_controller.text.isNotEmpty) {
                    count_controller.text =
                        (int.parse(count_controller.text.toString()) + 1)
                            .toString();
                    double old_price = product.getTotalPrice();

                    product.sell_count++;
                    controller.updateBillTotalVal(
                        old_price, product.getTotalPrice());
                    total_controller.text = product.getTotalPrice().toString();
                  }
                },
                icon: Icon(Icons.add)),
            Spacer(),
            Expanded(
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: count_controller,
                onChanged: (val) {
                  if (val.isNotEmpty)
                    try {
                      int count = int.parse(val);
                      if (count >= 1) {
                        double old_price = product.getTotalPrice();
                        product.sell_count = count;
                        controller.updateBillTotalVal(
                            old_price, product.getTotalPrice());
                      } else
                        count_controller.text = product.sell_count.toString();
                    } catch (e) {
                      count_controller.text = product.sell_count.toString();
                    }
                  else {
                    double old_price = product.getTotalPrice();

                    product.sell_count = 0;
                    controller.updateBillTotalVal(
                        old_price, product.getTotalPrice());
                  }
                  total_controller.text = product.getTotalPrice().toString();
                },
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  if (count_controller.text.isNotEmpty &&
                      product.sell_count > 1) {
                    count_controller.text =
                        (int.parse(count_controller.text.toString()) - 1)
                            .toString();
                    double old_price = product.getTotalPrice();

                    product.sell_count--;
                    controller.updateBillTotalVal(
                        old_price, product.getTotalPrice());

                    total_controller.text = product.getTotalPrice().toString();
                  }
                },
                icon: Icon(Icons.minimize)),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        MyTextfield(
          isReadOnly: true,
          validator: (val) {},
          controller: total_controller,
          hint: "السعر الكلي",
        ),
      ],
    );
  }
}
/////////////////////////////////////////////
//////////////Table Screen//////////////////
///////////////////////////////////////////

List<TableRow> productsDetailsTable() {
  var controller = Get.put(AddingOrderController());
  List<TableRow> rows = [
    const TableRow(
      children: [
        Center(
          child: Text(
            "اسم المنتج",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            "العدد",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            "السعر",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            "السعر الكلي",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    )
  ];
  bool noRebate = Product.rebate == 0 ? true : false;
  controller.order_list.value.forEach((element) {
    rows.add(TableRow(
      children: [
        Center(
          child: Text(
            element.product_name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              element.sell_count.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              element.new_price.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              noRebate
                  ? element.getTotalPrice().toString()
                  : (element.new_price * element.sell_count).toStringAsFixed(1),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ));
  });
  return rows;
}

class BillTables extends StatelessWidget {
  var controller = Get.put(AddingOrderController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(children: [
                  Center(
                    child: const Text(
                      "فاتوره مبيعات",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      "نوع الفاتورة",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      controller.current_selling_type.value,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(children: [
                  Center(
                    child: const Text(
                      "رقم الفاتوره",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      controller.bill_num.value.toString(),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      "التاريخ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        controller.date.value.toString(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(children: [
                  Center(
                    child: const Text(
                      "اسم العميل",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      controller.client_name.value,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Center(
                    child: Text(
                      "اسم المخزن",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      controller.store_name.value,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: productsDetailsTable(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(children: [
                  Center(
                    child: const Text(
                      "الاجمالي :",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        Product.rebate == 0
                            ? controller.bill_total_value.value
                                .toStringAsFixed(1)
                            : (controller.bill_total_value.value /
                                    (1 - Product.rebate / 100))
                                .toStringAsFixed(1),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: const Text(
                      "  الخصم: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        Product.rebate.toStringAsFixed(1),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(children: [
                  Center(
                    child: const Text(
                      "اجمالي المطلوب :",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        controller.bill_total_value.toStringAsFixed(1),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(whats),
              SizedBox(width: 10),
              Icon(
                Icons.phone,
                color: Colors.green,
                size: 40,
              ),
              const SizedBox(width: 40),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(facebook),
              SizedBox(width: 10),
              Icon(
                Icons.facebook,
                color: Colors.blue,
                size: 40,
              ),
              const SizedBox(width: 40),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(instagram),
              SizedBox(width: 10),
            ],
          ),
        ],
      )),
    );
  }
}
