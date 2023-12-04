// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../home_provider.dart';

class On_Sale_Products extends StatelessWidget {
  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    double parentHeight = MediaQuery.of(context).size.height * 0.37;
    double childHeight = MediaQuery.of(context).size.height * 0.32;
    return Container(
       width: MediaQuery.of(context).size.width,

      height: 700,
      // padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screen.width * 6),
            child: Text(
              "On Sale Products",
              style: GoogleFonts.poppins(
                  color: AppColor.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: screen.height * 2),
          Consumer<HomeProvider>(builder: (context, provider, child) {
            if (provider.featuredProductResponse != null) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height:600,
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  itemCount: provider.featuredProductResponse!.data!.length,
                  scrollDirection: Axis.horizontal,
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: ((188.w) / (268.h))),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      child: SizedBox(
                        width: 50,
                        height: childHeight,
                        child: ProductItem(
                          currentPrice: provider.featuredProductResponse!
                              .data![index].currentPrice,
                          hasDiscount: provider.featuredProductResponse!
                              .data![index].hasDiscount,
                          discount: provider.featuredProductResponse!
                                  .data![index].discount
                                  .toString() +
                              " %",
                          productId: provider
                              .featuredProductResponse!.data![index].id
                              .toString(),
                          productTitle: provider
                              .featuredProductResponse!.data![index].name
                              .toString(),
                          basePrice: provider
                              .featuredProductResponse!.data![index].basePrice
                              .toString(),
                          imageUrl: provider.featuredProductResponse!
                              .data![index].thumbnailImage
                              .toString(),
                          addToCart: () {},
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: childHeight,
                child: GridView.builder(
                  itemCount: 8,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: screen.width * 2,
                      mainAxisSpacing: screen.height * 1.5,
                      childAspectRatio:
                          ((screen.width * 40) / (screen.height * 35))),
                  itemBuilder: (context, index) {
                    return AppShimer(
                      width: 160,
                      height: childHeight,
                      // height: screen.height * 10,
                      // width: screen.width * 18,
                      borderRadius: screen.height,
                    );
                  },
                ),
              );
            }
          })
        ],
      ),
    );
  }
}
