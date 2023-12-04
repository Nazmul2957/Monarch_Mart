// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_font.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../product_details_provider.dart';

class ProdNameReview extends StatelessWidget {
  ProductDetailsProvider presenter;
  double width, height;

  ProdNameReview(
      {required this.presenter, required this.height, required this.width});

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Consumer<ProductDetailsProvider>(
      builder: (context, ob, child) {
        if (ob.response != null) {
          return mainRow();
        } else {
          return AppShimer(width: width * 90, height: height * 8);
        }
      },
    );
  }

  Widget mainRow() {
    return Padding(
      padding: EdgeInsets.only(left: width * 2.5, right: width * 2.5),
      child: Stack(
        alignment: Alignment.topRight,
        children: [subColumn1(), subColumn2()],
      ),
    );
  }

  Widget subColumn1() {
    return Container(
      width: width * 95,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(right: width * 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          productName(),
          SizedBox(height: height),
          ReviewBar(
              height: height * 2.75,
              width: height * 2.75,
              spacing: width * 1.5,
              ratingCount: presenter.response!.data![0].ratingCount.toString(),
              rating: presenter.response!.data![0].rating!.toDouble(),
              color: AppColor.primary,
              numberOfStars: 5),
        ],
      ),
    );
  }

  Widget productName() {
    return Container(
      width: width * 90,
      padding: EdgeInsets.only(right: width * 8),
      child: Text(
        presenter.response!.data![0].name.toString(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: height * 2.4,
          fontFamily: AppFont.Poppins,
          color: AppColor.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget subColumn2() {
    return Container(
      width: width * 25,
      height: height * 12,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xFFE2E3E4),
          // border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          presenter.response!.data![0].hasDiscount!
              ? Text(
                  presenter.response!.data![0].strokedPrice.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: height * 2,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Container(),
          Text(
            presenter.response!.data![0].mainPrice.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: height * 2,
              color: AppColor.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
