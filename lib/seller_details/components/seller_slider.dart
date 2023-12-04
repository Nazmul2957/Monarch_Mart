// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/seller_details/seller_details_provider.dart';
import 'package:provider/provider.dart';

class SellerSlider extends StatefulWidget {
  @override
  State<SellerSlider> createState() => _SellerSliderState();
}

class _SellerSliderState extends State<SellerSlider> {
  int currentSlider = 0;
  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Consumer<SellerDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.detailsResponse != null) {
          if (provider.detailsResponse!.data!.isNotEmpty) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      aspectRatio: 2.67,
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
                      onPageChanged: (currentSlider, reason) {
                        setState(() {
                          this.currentSlider = currentSlider;
                        });
                      }),
                  items: provider.detailsResponse!.data![0].sliders!
                      .map((imageAddress) => Builder(
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screen.height)),
                                  child: CachedImage(
                                    boxFit: BoxFit.fill,
                                    imageUrl: imageAddress.toString(),
                                  ),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var i = 0;
                      i < provider.detailsResponse!.data![0].sliders!.length;
                      i++)
                    dot(i)
                ]),
              ],
            );
          } else {
            return AppShimer(
              height: screen.height * 16,
              width: screen.width * 90,
              borderRadius: screen.height,
            );
          }
        } else {
          return AppShimer(
            height: screen.height * 16,
            width: screen.width * 90,
            borderRadius: screen.height,
          );
        }
      },
    );
  }

  Widget dot(int index) {
    return Container(
      width: screen.width * 2.5,
      height: screen.width * 2.5,
      margin: EdgeInsets.symmetric(
          vertical: screen.height, horizontal: screen.width * 1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentSlider == index
            ? AppColor.primary
            : Color.fromRGBO(112, 112, 112, .3),
      ),
    );
  }
}
