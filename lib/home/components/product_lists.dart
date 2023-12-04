// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/product_response.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/home/home_provider.dart';
import 'package:provider/provider.dart';

class ProductLists extends StatelessWidget {
  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screen.width * 2),
      child: Consumer<HomeProvider>(builder: (context, ob, child) {
        if (ob.productObjectList.isNotEmpty) {
          return Column(
            children: [
              for (var i = 0; i < ob.productObjectList.length; i++)
                ob.productObjectList[i].response!.data!.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 22.h,
                                child: Text(
                                  ob.productObjectList[i].title.toString(),
                                  style: GoogleFonts.poppins(
                                      color: AppColor.primary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              ob.productObjectList[i].title.toString() != ""
                                  ? Row(
                                      children: [
                                        OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                primary: AppColor.secondary),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, AppRoute.product,
                                                  arguments:
                                                      ScreenArguments(data: {
                                                    "numberofChildren": 0,
                                                    "subcategoryUrl": "",
                                                    "url": ob
                                                        .productObjectList[i]
                                                        .viewMoreProductLink,
                                                    "category": ob
                                                        .productObjectList[i]
                                                        .title
                                                  }));
                                            },
                                            child: Text(
                                              "View All",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                color: AppColor.secondary,
                                              ),
                                            )),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(height: 13.h),
                          gridItems(ob.productObjectList[i].response),
                          SizedBox(height: 12.h),
                        ],
                      )
                    : Container()
            ],
          );
        } else {
          return shimmer();
        }
      }),
    );
  }

  Widget gridItems(ProductResponse? response) {
    return GridView.builder(
      itemCount: response!.data!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 15.h,
          childAspectRatio: ((188.w) / (268.h))),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ProductItem(
          basePrice: response.data![index].basePrice.toString(),
          currentPrice: response.data![index].currentPrice.toString(),
          discount: response.data![index].discount.toString() + " %",
          hasDiscount: response.data![index].hasDiscount,
          productId: response.data![index].id.toString(),
          productTitle: response.data![index].name.toString(),
          imageUrl: response.data![index].thumbnailImage.toString(),
          addToCart: () {},
        );
      },
    );
  }

  Widget shimmer() {
    return GridView.builder(
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: screen.width * 2,
          mainAxisSpacing: screen.height * 1.5,
          childAspectRatio: ((screen.width * 40) / (screen.height * 35))),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return AppShimer(
          height: screen.height * 10,
          width: screen.width * 40,
          borderRadius: screen.height,
        );
      },
    );
  }
}
