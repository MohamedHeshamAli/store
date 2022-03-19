import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_store/constants.dart';
import 'package:my_store/pages/login/login_control.dart';
import 'package:my_store/pages/login/widgets.dart';

import '../home/home_screen.dart';

class LogineScreen extends StatelessWidget {
  var user_name_controller = TextEditingController();
  var pass_controller = TextEditingController();
  final login_controller = Get.put(LoginController());
  bool check = false;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 150),
      child: Form(
        key: formKey,
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.store_mall_directory_outlined,
                size: 100,
                color: Colors.orange,
              ),
              Text(
                "متجري",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "تسجيل الدخول",
                style: title_style,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextfield(
                  validator: (str) {
                    if (str == null || str.isEmpty)
                      return "برجاء ادخال اسم المستخدم";
                    else
                      return null;
                  },
                  controller: user_name_controller,
                  icon: Icons.person,
                  hint: "اسم المستخدم"),
              const SizedBox(
                height: 10,
              ),
              MyTextfield(
                  validator: (str) {
                    if (str == null || str.isEmpty)
                      return "برجاء ادخال كلمة المرور";
                    else
                      return null;
                  },
                  controller: pass_controller,
                  icon: Icons.lock,
                  IsPass: true,
                  hint: "كلمة المرور"),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                label: "تسجيل الدخول",
                onTaP: () async {
                  if (formKey.currentState!.validate()) {
                    check = await login_controller.checkLoginControl(
                      user_name_controller.text,
                      pass_controller.text,
                    );

                    if (!check)
                      showErrorDialog(context);
                    else
                      Get.to(HomeScreen());
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              GetX<LoginController>(
                builder: (_) {
                  if (login_controller.IsLoading.value)
                    return const CircularProgressIndicator();
                  else
                    return Container();
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
