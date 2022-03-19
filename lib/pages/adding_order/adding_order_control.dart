import 'package:get/get.dart';
import 'package:my_store/pages/adding_order/product.dart';
import 'package:my_store/constants.dart';

class AddingOrderController extends GetxController {
  var date =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"
          .obs;
  var bill_num = "".obs;
  var client_name = "".obs;
  var client_id = "".obs;
  var moneny_id = "".obs;
  var money_name = "".obs;
  var store_id = "".obs;
  var store_name = "".obs;
  RxList<String> money_list = [""].obs;
  RxList<String> money_list_id = [""].obs;
  var stores_name_list = [""].obs;
  var stores_id_list = [""].obs;
  var client_name_list = [""].obs;
  var client_id_list = [""].obs;
  var current_selling_type = "نقدي".obs;
  var selling_type_list = ["نقدي", "اجل"].obs;

  var products_list = [].obs;
  var stores_products_list = {}.obs;
  var searched_products_list = [].obs;
  var order_list = [].obs;
  var bill_details_list = [].obs;
  var is_client_screen = true.obs;
  RxDouble bill_total_value = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() async {
    _setStoresLists();
    _setMoneyLists();
    _setClientsLists();
    _setProducts();

    super.onInit();
  }

  Future save() async {
    var saved = false;
    isLoading.value = true;
    if (order_list.value.isNotEmpty) {
      try {
        int invo_num = await mySql!.getNextInvoNum();
        bill_num.value = invo_num.toString();
        DateTime timeOfDay = DateTime.now();
        String time =
            "${timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute}:${timeOfDay.minute} "
            "${timeOfDay.hour > 12 ? "PM" : "AM"}";

        int status = current_selling_type.value == "نقدي" ? 1 : 0;
        double profit = 0.0;
        bill_total_value.value = 0.0;
        order_list.value.forEach((element) {
          profit += element.getProfit();
          bill_total_value.value += element.getTotalPrice();
        });
        await mySql!.insertOrderMaster(
            date: date.value,
            time: time,
            value: bill_total_value.value,
            invo: invo_num,
            status: status,
            type: current_selling_type.value,
            id_of_client: client_id.value,
            nameOfClient: client_name.value,
            khasm: Product.rebate,
            id_of_money: moneny_id.value,
            name_of_money: money_name.value,
            name_of_story: store_name.value,
            id_of_story: store_id.value,
            reb7: profit,
            status_halk: "n",
            type_halk: "سليم",
            name_of_user: user_name,
            id_of_user: user_id);
        order_list.value.forEach((element) async {
          Product product = element;
          await mySql!.insertOrderDetails(
              invo: invo_num,
              id: product.id,
              name: product.product_name,
              quan: product.sell_count,
              price: product.new_price,
              tottal: product.getTotalPrice(),
              reb7: product.getProfit());
        });
        isLoading.value = false;
        return true;
      } catch (e) {
        isLoading.value = false;
        return false;
      }
    }
    isLoading.value = false;
    return saved;
  }

  void clearOrder() {
    order_list.value = [];
  }

  void changeDate(String date) {
    this.date.value = date;
  }

  void _setMoneyLists() async {
    var money_lists = await mySql!.getTreasuryes();
    money_list.value = money_lists[0];
    money_name.value = money_list[0];
    money_list_id.value = money_lists[1];
  }

  void _setClientsLists() async {
    Map clients = await mySql!.getClients();
    client_name_list.value = clients["name"];
    client_name.value = client_name_list.value[0];
    client_id_list.value = clients["id"];
    client_id.value = client_id_list[0];
  }

  void changeClientName(String nclient) {
    if (nclient != client_name.value) {
      client_name.value = nclient;
      client_id.value =
          client_id_list.value[client_name_list.value.indexOf(nclient)];
    }
  }

  void changeClientId(String id) {
    if (id != client_id.value) {
      client_id.value = id;
      client_name.value =
          client_name_list.value[client_id_list.value.indexOf(id)];
    }
  }

  void _setStoresLists() async {
    Map stores = await mySql!.getstores();
    stores_name_list.value = stores["name"];
    store_name.value = stores_name_list.value[0];
    stores_id_list.value = stores["id"];
  }

  void _setProducts() async {
    stores_products_list.value = await mySql!.getStoresProduct();

    products_list.value = stores_products_list.value[store_name.value];
    searched_products_list.value = products_list.value;
  }

  void setBillList() {
    bill_details_list.clear();
    order_list.value.forEach((element) {
      return bill_details_list.value.add(Product(
        id: element.id,
        buy_price: element.buy_price,
        count_in_store: element.count_in_store,
        price: element.price,
        product_name: element.product_name,
        sell_count: element.sell_count,
        new_price1: element.new_price,
      ));
    });
  }

  void initBillValue() {
    bill_total_value.value = 0.0;
    order_list.value.forEach(
        (product) => bill_total_value.value += product.getTotalPrice());
  }

  void updateBillTotalVal(double old_val, double new_val) {
    bill_total_value.value = bill_total_value.value + new_val - old_val;
  }

  void updateRebate(double old_val, double new_val) {
    bill_total_value.value *= old_val * new_val;
  }

  void removeItemfromBill(int index) {
    updateBillTotalVal(bill_details_list.value[index].getTotalPrice(), 0);
    bill_details_list.value.removeAt(index);
    update();
  }

  void saveBillChanges() {
    order_list.clear();
    order_list.addAll(bill_details_list);
    update();
  }

  void addOrder(Product product) {
    products_list.value.add(product);
  }

  void productSearch(String productName) {
    if (productName == null || productName.isEmpty) {
      searched_products_list.value = products_list.value;
    } else {
      searched_products_list.value = [];

      for (int i = 0; i < products_list.length; i++) {
        if (products_list.value[i].product_name.contains(productName))
          searched_products_list.value.add(products_list.value[i]);
      }
    }
  }

  void changeSellingType(String newVal) {
    current_selling_type.value = newVal;
  }

  void changeMoney(String newVal) {
    money_name.value = newVal;
  }

  void changeStore(String product_store) {
    if (product_store != store_name.value) {
      order_list.value = [];
      products_list.value = stores_products_list.value[product_store];
      searched_products_list.value = products_list.value;
    }
  }

  void changeScreen({required bool goToClientScreen}) {
    goToClientScreen
        ? is_client_screen.value = true
        : is_client_screen.value = false;
  }
}
