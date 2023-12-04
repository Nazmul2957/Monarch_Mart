import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isMobileLayout() {
  // The equivalent of the "smallestWidth" qualifier on Android.
  var shortestSide = MediaQuery.of(Get.context!).size.shortestSide;

// Determine if we should use mobile layout or not, 600 here is
// a common breakpoint for a typical 7-inch tablet.
  final bool useMobileLayout = shortestSide < 600;
  // print('useMobileLayout: $useMobileLayout');
  return useMobileLayout;
}

Future<void> saveSP(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> getStringSP(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '';
}
