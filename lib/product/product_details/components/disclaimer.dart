// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_font.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../product_details_provider.dart';

class Disclaimer extends StatelessWidget {
  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
      child: Consumer<ProductDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.response != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(title: "Disclaimer", color: AppColor.primary),
                SizedBox(height: screen.height),
                Text(
                  provider.response!.data![0].disclaimer.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: AppFont.Poppins),
                ),
                SizedBox(height: screen.height),
              ],
            );
          } else {
            return AppShimer(
              width: screen.width * 90,
              height: screen.height * 10,
            );
          }
        },
      ),
    );
  }
}
