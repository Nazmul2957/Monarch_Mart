// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/home/home_provider.dart';
import 'package:provider/provider.dart';

import '../../app_components/app_route.dart';
import '../../app_models/screen_aguments.dart';

class CarouselHome extends StatefulWidget {
  @override
  State<CarouselHome> createState() => _CarouselHomeState();
}

class _CarouselHomeState extends State<CarouselHome> {
  int currentSlider = 0;
  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Container(
      width: screen.width * 100,
      padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
      child: Consumer<HomeProvider>(builder: (context, ob, child) {
        if (ob.sliderResponse != null) {
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
                //add
                items: ob.sliderResponse!.data!
                    .map((imageAddress) => Builder(
                          builder: (context) {
                            return InkWell(
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screen.height)),
                                  child: CachedImage(
                                    boxFit: BoxFit.fill,
                                    placeHolder: AppImage.placeHolderRectangle,
                                    imageUrl: imageAddress.photo.toString(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < ob.carouselImageList.length; i++)
                  Expanded(child: dot(i))
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
      }),
    );
  }

  Widget dot(int index) {
    return Container(
      width: screen.width * 2.5,
      height: screen.width * 2.5,
      margin: EdgeInsets.symmetric(
          vertical: screen.height, horizontal: screen.width * 1.3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentSlider == index
            ? AppColor.primary
            : Color.fromRGBO(112, 112, 112, .3),
      ),
    );
  }
}
