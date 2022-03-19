import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  void Function()? onTap;
  IconData icon;
  String label;
  HomeCard({this.onTap, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                size: 200,
                color: Theme.of(context).primaryColor.withOpacity(.9),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                color: Colors.black54,
                width: 300,
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 2))
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
