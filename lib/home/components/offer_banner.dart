// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/home/home_provider.dart';
import 'package:provider/provider.dart';

class OfferBanner extends StatelessWidget {
  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Consumer<HomeProvider>(builder: (context, ob, child) {
      if (ob.bannerResponse != null) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoute.product,
                arguments: ScreenArguments(data: {
                  "numberofChildren": 0,
                  "subcategoryUrl": "",
                  "url": "/flash-deal-products/" +
                      ob.bannerResponse!.data![0].id.toString(),
                  "category": ""
                }));
          },
          child: ob.bannerResponse!.data!.isNotEmpty
              ? Container(
                  width: screen.width * 100,
                  height: screen.height * 18,
                  child: CachedImage(
                    imageUrl: ob.bannerResponse!.data![0].banner.toString(),
                    boxFit: BoxFit.fill,
                  ),
                )
              : Container(),
        );
      } else {
        return AppShimer(
          width: screen.width * 100,
          height: screen.height * 18,
        );
      }
    });
  }
}
