import 'dart:ffi';

import 'package:flutter/material.dart';

/////////////////////////////////////////////////////
/////////////login text form////////////////////////
/////////////////////////////////////////////////////
class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  String? Function(String?)? validator;
  IconData? icon;
  bool IsPass;
  bool isReadOnly;
  //String initialVal;
  Function()? onTap;
  void Function(String)? OnChanged;
  TextInputType? keyboardType;
  MyTextfield(
      {
      // Key key,
      this.keyboardType,
      required this.validator,
      this.OnChanged,
      this.isReadOnly = false,
      this.onTap,
      // this.initialVal = "",
      required this.controller,
      required this.hint,
      this.icon,
      this.IsPass = false});
  // : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: TextFormField(
          keyboardType: keyboardType,
          onChanged: OnChanged,
          onTap: onTap,
          readOnly: isReadOnly,
          validator: validator,
          controller: controller,
          obscureText: IsPass,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            label: Text(
              hint,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 2))
        ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
      );
}

class MyButton extends StatelessWidget {
  Function? onTaP;
  final String label;
  final Color? color;
  bool noMargin;
  double borderRaduis;
  MyButton(
      {this.onTaP,
      required this.label,
      this.color,
      this.noMargin = false,
      this.borderRaduis = 30});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin:
          noMargin ? null : EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      decoration: BoxDecoration(
          color: color == null ? Theme.of(context).primaryColor : color,
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 2))
          ],
          borderRadius: BorderRadius.circular(borderRaduis)),
      child: Center(
        child: GestureDetector(
          onTap: () {
            onTaP!();
          },
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}

showErrorDialog(BuildContext ctx) {
  showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text("خطأ",
                  style: TextStyle(color: Theme.of(ctx).primaryColor))),
          content: Text(
            "برجاء المحاوله مره اخرى",
            textDirection: TextDirection.rtl,
            style: TextStyle(color: Theme.of(ctx).primaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text("حسناً"),
            ),
          ],
        );
      });
}
