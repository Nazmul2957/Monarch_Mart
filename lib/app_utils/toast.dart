import 'package:flutter/material.dart';

class Toast {
  static createToast(
      {required BuildContext context,
      required String message,
      required Duration duration}) {
    double width, height;
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0.0,
        duration: duration,
        content: Container(
            width: width * 90,
            decoration: BoxDecoration(
                color: Color.fromRGBO(239, 239, 239, .9),
                borderRadius: BorderRadius.circular(height / 2),
                border: Border.all(width: width / 5, color: Colors.grey)),
            padding: EdgeInsets.symmetric(
                vertical: height * 1.5, horizontal: width * 2),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: height * 1.7),
            ))));
  }
}
