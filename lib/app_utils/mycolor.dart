import 'package:flutter/material.dart';

class MyColor {
  static Color getColor(String codeString) {
    return Color(int.parse(codeString.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
