
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/ordered_product_response.dart';
import 'package:provider/provider.dart';
import '../../../app_components/app_route.dart';
import '../../../app_models/screen_aguments.dart';
import '../order_details_provider.dart';

// ignore: must_be_immutable
class OrderedProduct extends StatelessWidget {
  OrderDetailsProvider presenter;
  double width, height;

  OrderedProduct(
      {required this.presenter, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsProvider>(
      builder: (context, ob, child) {
        if (ob.productResponse != null) {
          return Column(
            children: [
              headingBlock(),
              for (var i = 0; i < ob.productResponse!.data!.length; i++)
                singleProduct(context, ob.productResponse!.data![i]),
            ],
          );
        } else {
          return headingBlock();
        }
      },
    );
  }

  Widget headingBlock() {
    return Container(
      width: width * 90,
      height: height * 10,
      alignment: Alignment.center,
      child: Text(
        "Ordered Product",
        style: TextStyle(
            fontSize: height * 2,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
      ),
    );
  }

  Widget singleProduct(BuildContext context, Data data) {
    return Padding(
      padding: EdgeInsets.only(bottom: height),
      child: Container(
        width: width * 90,
        alignment: Alignment.center,
        padding: EdgeInsets.all(width * 2),
        decoration: BoxDecoration(
          border: Border.all(width: width / 8, color: AppColor.yellow),
          color: Color.fromARGB(255, 240, 239, 239),
          borderRadius: BorderRadius.circular(height),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        Padding(
        padding: EdgeInsets.symmetric(vertical: height / 2),
        child: Text(data.productName.toString(),
            style: TextStyle(
              fontSize: height * 1.7,
              color: AppColor.secondary,
              fontWeight: FontWeight.w600,
            )),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: height / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            data.variation != "" && data.variation != null
                ? Text(
                data.quantity.toString() +
                    " x " +
                    data.variation.toString(),
                style: TextStyle(
                  fontSize: height * 1.7,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ))
                : Text(data.quantity.toString() + " x item",
                style: TextStyle(
                  fontSize: height * 1.7,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            Text(data.price.toString(),
                style: TextStyle(
                  fontSize: height * 1.7,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.symmetric(vertical: height / 2),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: AppColor.primary,
                fixedSize: Size(100.w, 50.h)),
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.review,
                  arguments: ScreenArguments(data: {
                    "productId": data.productId.toString()
                  }));
            },
            child: Text("Review")
            ,
          )),
    ],
    )
    ,
    )
    ,
    );
  }
}
