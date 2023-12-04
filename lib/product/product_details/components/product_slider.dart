// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/product_details_response.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:provider/provider.dart';

import '../product_details_provider.dart';
import 'detailed_picture.dart';

class ProductSlider extends StatelessWidget {
  ProductDetailsProvider presenter;
  double width, height;

  ProductSlider(
      {required this.presenter, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(builder: (context, ob, child) {
      if (ob.response != null) {
        print(ob.response);
        if (ob.response!.data![0].photos != null) {
          return carousel(
              ob.response!.data![0].photos,
              ob.response!.data![0].hasDiscount,
              ob.response!.data![0].discount,
              ob.response!.data![0].calculablePrice);
        } else {
          return AppShimer(width: width * 100, height: height * 40);
        }
      } else {
        return AppShimer(width: width * 100, height: height * 40);
      }
    });
  }

  Widget carousel(List<Photos>? photos, bool? hasDiscount, double? discount,
      int? calculablePrice) {
    print(photos?.length);
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: width / 10)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider(
                    carouselController: presenter.carouselController,
                    options: CarouselOptions(
                      aspectRatio: (100 / 40) * (width / height),
                      viewportFraction: 1,
                      initialPage: presenter.currentSlider,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        presenter.setCurrentSlider(index);
                      },
                    ),
                    items: photos!
                        .map((photo) => Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    DetailedPicture.show(
                                        context, photo.path.toString());
                                  },
                                  child: CachedImage(
                                    boxFit: BoxFit.contain,
                                    imageUrl: photo.path.toString(),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0;
                              i < presenter.response!.data![0].photos!.length;
                              i++)
                            dot(i)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 1.75),
          ],
        ),
        hasDiscount!
            ? Positioned(
                left: width * 2.5,
                child: Container(
                  height: height * 3.5,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: width),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height / 2),
                    color: Colors.red,
                  ),
                  child: Text(
                    ((1 - (calculablePrice! / (calculablePrice + discount!))) *
                                100)
                            .toStringAsFixed(0) +
                        " %",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: height * 1.8,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ))
            : Container()
      ],
    );
  }

  Widget dot(int index) {
    return Container(
      width: width * 2.5,
      height: width * 2.5,
      margin: EdgeInsets.symmetric(vertical: height, horizontal: width * 1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: presenter.currentSlider == index
            ? AppColor.primary
            : Color.fromRGBO(112, 112, 112, .3),
      ),
    );
  }
}
