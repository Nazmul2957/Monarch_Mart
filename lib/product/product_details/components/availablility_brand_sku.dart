// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/product/product_details/product_details_provider.dart';
import 'package:provider/provider.dart';

class AvailabilityBrandSku extends StatelessWidget {
  late double width, height;

  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    return Consumer<ProductDetailsProvider>(
      builder: (context, provier, child) {
        return Container(
          width: width * 100,
          padding: EdgeInsets.symmetric(horizontal: width * 2.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 90,
                child: MyText(
                    name: "SKU",
                    value: provier.currentSku,
                    valueColor: AppColor.valueColor,
                    valueFieldWidth: width * 65,
                    nameFontSize: height * 2,
                    valueFontSize: height * 2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 45,
                    child: MyText(
                        name: "Availability",
                        value: provier.inStock ? "Instock" : "stock out",
                        valueColor: AppColor.valueColor,
                        nameFontSize: height * 2,
                        valueFontSize: height * 2),
                  ),
                  InkWell(
                    onTap: () {
                      if (provier.brand != "Not Found") {
                        Navigator.pushNamed(context, AppRoute.product,
                            arguments: ScreenArguments(data: {
                              "numberofChildren": 0,
                              "subcategoryUrl": "",
                              "url": provier.brandLink,
                              "category": ""
                            }));
                      }
                    },
                    child: Container(
                      width: width * 45,
                      child: BrandText(
                          name: "Brand",
                          value: provier.brand,
                          valueColor: Colors.blue,
                          nameFontSize: height * 2,
                          valueFontSize: height * 2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
