// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/seller_details/seller_details_provider.dart';
import 'package:provider/provider.dart';

class LogoNameReview extends StatelessWidget {
  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Consumer<SellerDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.detailsResponse != null) {
          if (provider.detailsResponse!.data!.isNotEmpty) {
            return Container(
                child: Row(
              children: [
                image(provider.detailsResponse!.data![0].logo.toString()),
                SizedBox(width: screen.width * 2),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sellerTitle(
                        provider.detailsResponse!.data![0].name.toString()),
                    ReviewBar(
                        height: screen.height * 3,
                        width: screen.width * 5,
                        spacing: screen.width * 2,
                        rating: provider.detailsResponse!.data![0].rating!,
                        color: Colors.grey.shade300,
                        ratingCount: provider
                            .detailsResponse!.data![0].trueRating
                            .toString(),
                        numberOfStars: 5),
                  ],
                )
              ],
            ));
          } else {
            return Center();
          }
        } else {
          return shimer();
        }
      },
    );
  }

  Widget image(String url) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screen.height),
          side:
              BorderSide(color: Colors.grey.shade200, width: screen.width / 6)),
      child: Container(
          width: screen.width * 19,
          height: screen.width * 19,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screen.height),
            color: Colors.white,
          ),
          child: CachedImage(
            imageUrl: url,
            boxFit: BoxFit.fill,
          )),
    );
  }

  Widget sellerTitle(String sellerTitle) {
    return Padding(
      padding: EdgeInsets.only(left: screen.width / 2),
      child: Text(
        sellerTitle,
        style: TextStyle(
            fontSize: screen.height * 1.8,
            fontWeight: FontWeight.w600,
            color: Colors.black87),
      ),
    );
  }

  Widget shimer() {
    return Container(
      width: screen.width * 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppShimer(
            height: screen.width * 19,
            width: screen.width * 19,
            borderRadius: screen.height,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppShimer(
                height: screen.width * 70,
                width: screen.height * 3,
                borderRadius: screen.height,
              ),
              SizedBox(height: screen.height / 2),
              AppShimer(
                height: screen.width * 70,
                width: screen.height * 2.5,
                borderRadius: screen.height,
              ),
            ],
          )
        ],
      ),
    );
  }
}
