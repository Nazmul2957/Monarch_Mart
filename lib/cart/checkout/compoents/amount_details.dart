import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/checkout_summary_response.dart';

class AmountDetails {
  static void openDialog(
      {required BuildContext context, CheckoutSummaryResponse? response}) {
    showDialog(
        context: context,
        builder: (context) => AmountWindow(response: response!));
  }
}

// ignore: must_be_immutable
class AmountWindow extends StatelessWidget {
  CheckoutSummaryResponse response;
  AmountWindow({required this.response});
  late double statusbar, width, height;
  @override
  Widget build(BuildContext context) {
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    return Dialog(
      child: Container(
        height: height * 40,
        width: width * 80,
        padding: EdgeInsets.symmetric(horizontal: width * 5),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 3),
            singleitem("SUB TOTAL", response.subTotal.toString()),
            singleitem("TAX", response.tax.toString()),
            singleitem("SHIPPING COST", response.shippingCost.toString()),
            singleitem("DISCOUNT", response.discount.toString()),
            Container(
                width: width * 60, height: height / 5, color: Colors.grey),
            singleitem("GRAND TOTAL", response.grandTotal.toString()),
            SizedBox(height: height * 5),
          ],
        ),
      ),
    );
  }

  Widget singleitem(String titles, String price) {
    return Row(
      children: [
        Container(
          width: width * 30,
          height: height * 4,
          alignment: Alignment.centerRight,
          child: Text(
            titles,
            style: TextStyle(
              color: AppColor.secondary,
              fontSize: height * 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: width * 30,
          height: height * 4,
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
