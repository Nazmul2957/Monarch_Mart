// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:shimmer/shimmer.dart';

class AppShimer extends StatelessWidget {
  double? borderRadius;
  double height, width;
  AppShimer({
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
              )),
        ),
        baseColor: AppColor.shimmerbase,
        highlightColor: AppColor.shimmerhighlighted);
  }
}
