import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';

class LoadingProgrss {
  static void showProgress(BuildContext context) => showDialog(
        barrierColor: Colors.white.withOpacity(0.01),
        context: context,
        builder: (context) {
          double width = MediaQuery.of(context).size.width / 100;
          Future.delayed(Duration(milliseconds: 600), () {
            Navigator.of(context).pop(true);
          });
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              width: width * 35,
              height: width * 35,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: width * 10,
                    height: width * 10,
                    child: CircularProgressIndicator(
                        color: AppColor.primary,
                        backgroundColor: Colors.black,
                        strokeWidth: width),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
