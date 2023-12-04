// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../product_details_provider.dart';

class TopSellingProducts extends StatelessWidget {
  ProductDetailsProvider presenter;
  double width, height;

  TopSellingProducts(
      {required this.presenter, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, ob, child) {
        if (ob.response != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height),
              Container(
                  width: width * 90,
                  alignment: Alignment.centerLeft,
                  child: Header(
                      title: "Top Selling Products", color: AppColor.primary)),
              SizedBox(height: height * 2),
              ob.response?.data![0].relatedProducts?.data?.length != 0
                  ? similarProductList()
                  : Text("No Product Available"),
              SizedBox(height: height * 2),
            ],
          );
        } else {
          return AppShimer(width: width * 90, height: height * 15);
        }
      },
    );
  }

  Widget similarProductList() {
    return Container(
      height: height * 16,
      width: width * 95,
      alignment: Alignment.center,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: presenter.response?.data![0].relatedProducts?.data?.length,
        itemBuilder: (context, index) {
          return Container(
            width: width * 30,
            height: height * 14,
            child: ProductGridMini(
              id: presenter.response!.data![0].relatedProducts!.data![index].id
                  .toString(),
              height: height,
              width: width,
              name: presenter
                  .response!.data![0].relatedProducts!.data![index].name
                  .toString(),
              price: presenter
                  .response!.data![0].relatedProducts!.data![index].basePrice
                  .toString(),
              imageUrl: presenter.response!.data![0].relatedProducts!
                  .data![index].thumbnailImage
                  .toString(),
            ),
          );
        },
      ),
    );
  }
}
