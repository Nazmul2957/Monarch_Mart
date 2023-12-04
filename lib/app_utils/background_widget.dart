// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';

import 'app_screen.dart';

class Background extends StatelessWidget {
  Widget child;
  double? height;
  Background({required this.child, this.height});
  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(),
            Container(
              width: double.infinity,
              height: height ?? screen.height * 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screen.height * 2),
                color: AppColor.primary,
              ),
            )
          ],
        ),
        child,
      ],
    );
  }
}
