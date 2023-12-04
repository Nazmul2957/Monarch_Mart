// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';

import 'app_screen.dart';

class Categoryback extends StatelessWidget {
  Widget child;
  Categoryback({required this.child});

  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              child: child,
            ),
            Container(
              width: double.infinity,
              height: screen.height * 25,
              decoration: BoxDecoration(
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
