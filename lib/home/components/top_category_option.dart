// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_models/top_category_option_response.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/home/home_provider.dart';
import 'package:provider/provider.dart';

class TopCategoryOption extends StatelessWidget {
  late AppScreen screen;
  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    this.context = context;
    return Container(
      width: screen.width * 100,
      decoration: BoxDecoration(
        color: AppColor.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Categories",
                  style: GoogleFonts.poppins(
                      color: AppColor.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoute.category, (route) => false,
                        arguments:
                            ScreenArguments(data: {"url": "/categories"}));
                  },
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: AppColor.primary,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              if (provider.categroyOption != null) {
                return Container(
                  width: double.infinity,
                  height: 100.h,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.categroyOption!.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: singleItem(provider.categroyOption, index),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  width: double.infinity,
                  height: 100.h,
                  child: ListView.builder(
                    itemCount: 6,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Column(
                          children: [
                            AppShimer(
                                height: 56.h, width: 56.w, borderRadius: 10.r),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget singleItem(TopCategroyOptionResponse? response, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.product,
            arguments: ScreenArguments(data: {
              "url": response?.data?[index].links?.products,
              "category": response?.data?[index].name,
              "numberofChildren": response?.data?[index].numberOfChildren,
              "subcategoryUrl": response?.data?[index].links?.subCategories
            }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              child: CachedImage(
                imageUrl: response!.data![index].banner.toString(),
              )),
          Container(
            width: 56.w,
            padding: EdgeInsets.only(top: screen.height / 2),
            alignment: Alignment.center,
            child: Text(
              response.data![index].name.toString(),
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: AppColor.white,
                  fontSize: 10.sp),
            ),
          )
        ],
      ),
    );
  }
}
