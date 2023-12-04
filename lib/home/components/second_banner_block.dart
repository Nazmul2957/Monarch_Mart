// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/home/home_provider.dart';
import 'package:provider/provider.dart';

import '../../app_models/screen_aguments.dart';

class SecondBannerBlock extends StatelessWidget {
  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Consumer<HomeProvider>(builder: (context, ob, child) {
      if (ob.secondBannerBlock != null) {
        if (ob.secondBannerBlock?.data?.isNotEmpty ?? false) {
          return Container(
            width: double.infinity,
            height: 160.h,
            child: CarouselSlider(
              options: CarouselOptions(
                  height: 160.h,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.easeInCubic,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (currentSlider, reason) {}),
              items: ob.secondBannerBlock?.data
                  ?.map((imageAddress) => Builder(
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoute.product,
                                      arguments: ScreenArguments(data: {
                                        "numberofChildren": 0,
                                        "subcategoryUrl": "",
                                        "url": imageAddress.url,
                                        "category": ""
                                      }));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 160.h,
                                  child: CachedImage(
                                    imageUrl: imageAddress.photo.toString(),
                                    boxFit: BoxFit.fill,
                                  ),
                                )),
                          );
                        },
                      ))
                  .toList(),
            ),
          );
        } else {
          return Container();
        }
      } else {
        return AppShimer(width: double.infinity, height: 126.h);
      }
    });
  }
}
