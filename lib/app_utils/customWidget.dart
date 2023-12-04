import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

Widget customImageAvatar(
    {String? imgUrl,
    double? width,
    double? height,
    BoxShape? shape,
    Widget? placeholder,
    Widget? errorWidget}) {
  return CachedNetworkImage(
    imageUrl: imgUrl!,
    errorWidget: (context, url, error) => errorWidget ?? Container(),
    placeholder: (context, url) => placeholder ?? Container(),
    imageBuilder: (context, imageProvider) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: shape!,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          )),
    ),
  );
}

Widget buildCustomDecoration({
  double? width,
  double? height,
  Decoration? decoration,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  Widget? child,
}) {
  return Padding(
    padding: margin ?? const EdgeInsets.all(0),
    child: SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: decoration ?? BoxDecoration(),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0.0),
          child: child,
        ),
      ),
    ),
  );
}

Widget buildColorBox({
  double? width,
  double? height,
  Color? color,
  Widget? child,
  EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    width: width,
    height: height,
    child: ColoredBox(
      color: color ?? Colors.green,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0.0),
        child: child,
      ),
    ),
  );
}

Widget imageAvatar(
    {String? imgUrl,
    String? assetUrl,
    double? width,
    double? height,
    double? borderRadius,
    BoxShape? shape,
    Widget? placeholder,
    Widget? errorWidget}) {
  return CachedNetworkImage(
    imageUrl: imgUrl!,
    errorWidget: (context, url, error) => ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: errorWidget ??
          Image.asset(
            assetUrl ?? 'assets/image.png',
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
    ),
    placeholder: (context, url) => ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: placeholder ??
          Image.asset(
            assetUrl ?? 'assets/image.png',
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
    ),
    imageBuilder: (context, imageProvider) => buildCustomDecoration(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          )),
    ),
  );
}

Widget buildText(
    {String? text,
    Color? color,
    double? fontSize,
    TextDecoration? decoration,
    TextAlign? textAlign,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow? overflow}) {
  return Text(
    text!,
    textAlign: textAlign,
    maxLines: maxLines ?? null,
    overflow: overflow,
    style: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 16,
        decoration: decoration,
        fontWeight: fontWeight != null ? fontWeight : FontWeight.w400),
  );
}

Widget buildSetColorSpecificWordText(
    {String? text, Color? color, double? fontSize, FontWeight? fontWeight}) {
  return RichText(
    text: TextSpan(
      text: text,
      style: TextStyle(
          fontSize: fontSize,
          color: color != null ? color : Colors.black,
          fontWeight: fontWeight == null ? FontWeight.w400 : fontWeight),
      children: const <TextSpan>[
        TextSpan(
            text: ' *',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        // TextSpan(text: ' world!'),
      ],
    ),
  );
}

Widget buildColorText(
    {String? text,
    String? colorText,
    Color? color,
    Color? colorTextColor,
    double? fontSize,
    int? maxLine,
    bool? showUnderline,
    double? colorFontSize,
    FontWeight? fontWeight,
    FontWeight? colorFontWeight,
    GestureTapCallback? onTap}) {
  return RichText(
    maxLines: maxLine ?? null,
    text: TextSpan(
      text: text,
      style: TextStyle(
          fontSize: fontSize,
          color: color != null ? color : Colors.black,
          fontWeight: fontWeight == null ? FontWeight.w400 : fontWeight),
      children: <TextSpan>[
        TextSpan(
            text: colorText,
            style: TextStyle(
              fontSize: colorFontSize ?? fontSize,
              fontWeight:
                  colorFontWeight == null ? FontWeight.bold : colorFontWeight,
              decoration: showUnderline != null && showUnderline
                  ? TextDecoration.underline
                  : null,
              color: colorTextColor != null ? colorTextColor : Colors.red,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap),

        // TextSpan(text: ' world!'),
      ],
    ),
  );
}

Widget buildButtonTextLoader(
    {required String btnText, required bool showLoader}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(showLoader?'Loading...':btnText),
      Visibility(
        visible: showLoader,
        child: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      )
    ],
  );
}

Widget buildCustomButton(
    {double? width,
    double? height,
    double? borderRadius,
    VoidCallback? onTap,
    Color? bgColor,
    Color? shadowColor,
    BoxBorder? border,
    Widget? child,
    bool? isUploading,
    ShapeBorder? shape}) {
  return InkWell(
    onTap: isUploading != null && isUploading ? null : onTap,
    child: buildCustomDecoration(
      width: width,
      height: height ?? 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 6),
        border: border,
        color: isUploading != null && isUploading
            ? Colors.grey[300]
            : bgColor ?? Colors.teal,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: isUploading != null && isUploading
                ? Colors.grey[50]!
                : shadowColor ?? Colors.teal,
            blurRadius: 14.0,
            offset: new Offset(0.0, 4.0),
          ),
        ],
      ),
      child: isUploading != null && isUploading
          ? Center(
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )))
          : Center(child: child),
    ),
  );
}

Widget buildRequiredField(String title) {
  return buildText(text: title, color: Colors.red, fontSize: 12);
}
