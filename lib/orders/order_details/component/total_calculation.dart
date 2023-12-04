import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:provider/provider.dart';

import '../order_details_provider.dart';

// ignore: must_be_immutable
class TotalCalculation extends StatelessWidget {
  OrderDetailsProvider presenter;
  double width, height;
  TotalCalculation(
      {required this.presenter, required this.width, required this.height});

  late int stepIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsProvider>(builder: (context, ob, child) {
      if (ob.response != null) {
        return Container(
          padding: EdgeInsets.all(width * 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height),
              border: Border.all(width: width / 6, color: AppColor.yellow)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: height * 0.3),
              singleitem(
                  "SUB TOTAL", ob.response!.data![0].subtotal.toString()),
              singleitem("TAX", ob.response!.data![0].tax.toString()),
              singleitem("SHIPPING COST",
                  ob.response!.data![0].shippingCost.toString()),
              singleitem(
                  "DISCOUNT", ob.response!.data![0].couponDiscount.toString()),
              Container(
                  width: width * 70, height: height / 5, color: Colors.grey),
              singleitem(
                  "GRAND TOTAL", ob.response!.data![0].grandTotal.toString()),
              SizedBox(height: height * 0.3),
            ],
          ),
        );
      } else {
        return AppShimer(
          width: width * 90,
          height: height * 20,
        );
      }
    });
  }

  Widget singleitem(String titles, String price) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: height / 6),
          child: Container(
            padding: EdgeInsets.all(6),
            width: width * 45,
            color: Color.fromARGB(255, 240, 239, 239),
            height: height * 4,
            alignment: Alignment.centerLeft,
            child: Text(
              titles,
              style: TextStyle(
                color: AppColor.secondary,
                fontSize: height * 1.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(6),
          width: width * 40,
          height: height * 4,
          color: Color.fromARGB(255, 240, 239, 239),
          alignment: Alignment.centerRight,
          child: Text(
            price,
            style: TextStyle(
              color: AppColor.secondary,
              fontSize: height * 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
