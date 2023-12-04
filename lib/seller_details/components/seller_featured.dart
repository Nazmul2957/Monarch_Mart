// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/product_response.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/seller_details/seller_details_provider.dart';
import 'package:provider/provider.dart';

class SellerFeatured extends StatelessWidget {
  SellerDetailsProvider provider;
  late double width, height;
  SellerFeatured({required this.provider});
  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    return Padding(
      padding: EdgeInsets.only(top: height),
      child: Consumer<SellerDetailsProvider>(
        builder: (context, ob, child) {
          if (ob.featuredResponse != null) {
            if (ob.featuredResponse!.data!.isNotEmpty) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: height),
                    Header(
                      title: "Featured Product",
                      color: AppColor.primary,
                    ),
                    SizedBox(height: height),
                    ob.featuredResponse!.data!.length != 0
                        ? gridItems(ob.featuredResponse)
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
            return shimmer();
          }
        },
      ),
    );
  }

  Widget gridItems(ProductResponse? response) {
    return GridView.builder(
      itemCount: response!.data!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: width * 2.5,
          mainAxisSpacing: width * 2.5,
          childAspectRatio: ((width * 40) / (height * 35))),
      padding: EdgeInsets.all(height),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ProductItem(
          currentPrice: response.data![index].currentPrice,
          discount: response.data![index].discount.toString() + " %",
          hasDiscount: response.data![index].hasDiscount,
          productId: response.data![index].id.toString(),
          addToCart: () {},
          productTitle: response.data![index].name.toString(),
          imageUrl: response.data![index].thumbnailImage.toString(),
          basePrice: response.data![index].basePrice.toString(),
        );
      },
    );
  }

  Widget shimmer() {
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
