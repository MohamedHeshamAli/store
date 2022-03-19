class Product {
  double price;
  double buy_price;
  late double new_price;
  static double rebate = 0;
  String product_name;
  String id;
  int sell_count;
  int count_in_store;
  Product(
      {required this.price,
      required this.id,
      required this.buy_price,
      required this.product_name,
      required this.count_in_store,
      this.sell_count = 1,
      double? new_price1}) {
    if (new_price1 != null)
      this.new_price = new_price1;
    else
      this.new_price = this.price;
  }
  set newPrice(double price) {
    this.new_price = price;
  }

  void setRebate(double val) {
    rebate = val;
  }

  double getProfit() {
    return getTotalPrice() - (sell_count * buy_price);
  }

  double getTotalPrice() => (new_price - rebate / 100 * new_price) * sell_count;
}
