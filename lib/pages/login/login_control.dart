import 'package:get/get.dart';
import 'package:my_store/connections/my_sql.dart';
import 'package:my_store/constants.dart';

class LoginController extends GetxController {
  var IsLoading = false.obs;
  Future<bool> checkLoginControl(String userName, String pass) async {
    bool check;
    IsLoading.value = true;
    try {
      mySql = MySql();
      check = await mySql!.checkLogin(userName, pass);
    } catch (e) {
      check = false;
    }

    IsLoading.value = false;

    return check;
  }
}
