// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/seller_details/seller_details_provider.dart';
import 'package:provider/provider.dart';

class NewArrivals extends StatelessWidget {
  late double width, height;
  SellerDetailsProvider provider;
  NewArrivals({required this.provider});
  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    return Padding(
      padding: EdgeInsets.only(top: height),
      child: Consumer<SellerDetailsProvider>(
        builder: (context, ob, child) {
          if (ob.newArrivalResponse != null) {
            if (ob.newArrivalResponse!.data!.isNotEmpty) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: height),
                    Header(
                      title: "New Arrivals",
                      color: AppColor.primary,
                    ),
                    SizedBox(height: height),
                    ob.newArrivalResponse!.data!.length != 0
                        ? newArrivalProductList()
                        : Container(
                            width: width * 90,
                            height: height * 10,
                            alignment: Alignment.center,
                            child: Text("No  Product Available")),
                    SizedBox(height: height * 2),
                  ],
                ),
              );
            } else {
              return Container();
            }
          } else {
            return shimer();
          }
        },
      ),
    );
  }

  Widget newArrivalProductList() {
    return GridView.builder(
      itemCount: provider.newArrivalResponse!.data!.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: width * 2.5,
          mainAxisSpacing: height * 2.5,
          childAspectRatio: ((width * 40) / (height * 33))),
      itemBuilder: (context, index) {
        return Container(
          width: width * 25,
          padding: EdgeInsets.only(right: width * 2),
          child: ProductItem(
            addToCart: () {},
            hasDiscount: provider.newArrivalResponse!.data![index].hasDiscount,
            currentPrice:
                provider.newArrivalResponse!.data![index].currentPrice,
            discount:
                provider.newArrivalResponse!.data![index].discount.toString() +
                    " %",
            basePrice:
                provider.newArrivalResponse!.data![index].basePrice.toString(),
            productId: provider.newArrivalResponse!.data![index].id.toString(),
            productTitle:
                provider.newArrivalResponse!.data![index].name.toString(),
            imageUrl: provider.newArrivalResponse!.data![index].thumbnailImage
                .toString(),
          ),
        );
      },
    );
  }

  Widget shimer() {
    return GridView.builder(
      itemCount: 8,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: width * 2,
          mainAxisSpacing: height * 1.5,
          childAspectRatio: ((width * 40) / (height * 35))),
      itemBuilder: (context, index) {
        return AppShimer(
          height: height * 10,
          width: width * 18,
          borderRadius: height,
        );
      },
    );
  }
}
