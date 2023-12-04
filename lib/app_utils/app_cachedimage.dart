// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_image.dart';

class CachedImage extends StatelessWidget {
  String imageUrl;
  BoxFit? boxFit;
  String? placeHolder;

  CachedImage({required this.imageUrl, this.boxFit, this.placeHolder});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit == null ? BoxFit.contain : boxFit,
          ),
        ),
      ),
      placeholder: (context, url) => Image(
        image: placeHolder == null
              ? AssetImage(AppImage.placeHolder)
              : AssetImage(placeHolder.toString()),
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => Image(
          image: placeHolder == null
              ? AssetImage(AppImage.placeHolder)
              : AssetImage(placeHolder.toString()),
          fit: BoxFit.cover,
        ),
      );
  }
}
