import 'package:flutter/material.dart';

class AppScreen {
  late double width, height, statusbar;

  AppScreen(BuildContext context) {
    var _sizeObject = MediaQuery.of(context);
    statusbar = _sizeObject.padding.top;
    height = (_sizeObject.size.height - statusbar) / 100;
    width = _sizeObject.size.width / 100;
  }
}
