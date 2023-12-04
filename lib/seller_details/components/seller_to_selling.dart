import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/seller_details/seller_details_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SellerToSelling extends StatelessWidget {
  SellerDetailsProvider presenter;
  late double width, height;
  SellerToSelling({required this.presenter});

  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    return Padding(
      padding: EdgeInsets.only(top: height),
      child: Consumer<SellerDetailsProvider>(
        builder: (context, ob, child) {
          if (ob.topResponse != null) {
            if (ob.topResponse!.data!.isNotEmpty) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: height),
                    Header(
                      title: "Top Selling Product",
                      color: AppColor.primary,
                    ),
                    SizedBox(height: height),
                    ob.topResponse!.data!.length != 0
                        ? topSellingProductList()
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

  Widget topSellingProductList() {
    return GridView.builder(
      itemCount: presenter.topResponse!.data!.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: width * 2.5,
          mainAxisSpacing: height * 2.5,
          childAspectRatio: ((width * 40) / (height * 33))),
      itemBuilder: (context, index) {
        return ProductItem(
          productId: presenter.topResponse!.data![index].id.toString(),
          addToCart: () {},
          discount:
              presenter.topResponse!.data![index].discount.toString() + " %",
          currentPrice: presenter.topResponse!.data![index].currentPrice,
          hasDiscount: presenter.topResponse!.data![index].hasDiscount,
          productTitle: presenter.topResponse!.data![index].name.toString(),
          basePrice: presenter.topResponse!.data![index].basePrice.toString(),
          imageUrl:
              presenter.topResponse!.data![index].thumbnailImage.toString(),
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
