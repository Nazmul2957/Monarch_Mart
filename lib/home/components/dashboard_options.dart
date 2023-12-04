// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';

class DashboardOptions extends StatelessWidget {
  late BuildContext context;
  var items = [
    {"name": "Top Sellers", "img": AppImage.sale},
    {"name": "Top Brands", "img": AppImage.topBrands},
    {"name": "Best Selling", "img": AppImage.bestSelling},
    {"name": "New Arrival", "img": AppImage.newArrival},
    {"name": "All Offers", "img": AppImage.allOffer},
  ];

  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    this.context = context;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          itemWidget(0),
          itemWidget(1),
          itemWidget(2),
          itemWidget(3),
          itemWidget(4)
        ],
      ),
    );
  }

  Widget itemWidget(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, AppRoute.filteredProduct,
                    arguments:
                        ScreenArguments(data: {"category": AppString.Seller}));
                break;
              case 1:
                Navigator.pushNamed(context, AppRoute.filteredProduct,
                    arguments:
                        ScreenArguments(data: {"category": AppString.Brands}));
                break;
              case 2:
                Navigator.pushNamed(context, AppRoute.product,
                    arguments: ScreenArguments(data: {
                      "url": "/products/best-seller",
                      "category": "",
                      "numberofChildren": 0,
                      "subcategoryUrl": ""
                    }));
                break;
              case 3:
                Navigator.pushNamed(context, AppRoute.filteredProduct,
                    arguments: ScreenArguments(
                        data: {"category": AppString.New_Products}));
                break;

              default:
                Navigator.pushNamed(context, AppRoute.allOffers,
                    arguments: ScreenArguments(data: {"option": false}));
                break;
            }
          },
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screen.height),
              color: AppColor.primary.withOpacity(0.1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Image(
                image: AssetImage(items[index]["img"].toString()),
                color: AppColor.primary,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Text(
            items[index]["name"].toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColor.black,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
