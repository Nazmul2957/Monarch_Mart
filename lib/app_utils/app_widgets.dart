// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_font.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';

import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';

import 'app_screen.dart';

class Header extends StatelessWidget {
  String title;
  TextAlign? textAlign;
  Color? color;

  Header({required this.title, this.textAlign, this.color});

  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.left,
      style: TextStyle(
          color: color ?? AppColor.black,
          fontFamily: AppFont.Poppins,
          fontSize: screen.height * 2.5,
          fontWeight: FontWeight.w600),
    );
  }
}

class SubCategoryItem extends StatelessWidget {
  String imageUrl;
  String title;
  Function ontap;
  Color borderColor;

  SubCategoryItem(
      {required this.imageUrl,
      required this.title,
      required this.ontap,
      required this.borderColor});

  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screen.height),
            side: BorderSide(
                color: Colors.grey.shade200, width: screen.width / 6)),
        child: Container(
          width: screen.width * 23,
          padding: EdgeInsets.symmetric(vertical: screen.width),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor, width: screen.width),
            borderRadius: BorderRadius.circular(screen.height),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: screen.height * 7,
                  width: screen.width * 17,
                  padding: EdgeInsets.only(
                      top: screen.height,
                      left: screen.width,
                      right: screen.width),
                  child: CachedImage(
                    imageUrl: imageUrl,
                  )),
              Container(
                width: screen.width * 20,
                padding: EdgeInsets.only(top: screen.height / 6),
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black87, fontSize: screen.height * 1.3),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  String productTitle;
  String basePrice;
  String? currentPrice;
  Function addToCart;
  String imageUrl;
  String? discount;

  bool? hasDiscount;
  String productId;

  ProductItem(
      {required this.productId,
      required this.productTitle,
      required this.basePrice,
      required this.addToCart,
      required this.imageUrl,
      this.currentPrice,
      this.hasDiscount = false,
      this.discount});

  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.product_details,
            arguments: ScreenArguments(data: {"productId": productId}));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColor.itemBackground,
            borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: 158.w,
                  height: 158.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screen.height * 2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screen.height * 2),
                    child: CachedImage(
                      imageUrl: imageUrl,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                ),
                hasDiscount!
                    ? Positioned(
                        top: 24.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          height: 27.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.r),
                                  bottomRight: Radius.circular(5.r))),
                          child: Text(discount.toString(),
                              style: GoogleFonts.poppins(
                                  color: AppColor.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                      )
                    : Positioned(
                        top: screen.height * 4,
                        child: Container(
                          width: screen.width * 15,
                          height: screen.height * 4,
                          color: Colors.transparent,
                        ),
                      )
              ],
            ),
            SizedBox(height: 15.h),
            Container(
              width: 160.w,
              child: Text(
                productTitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    letterSpacing: 1.sp,
                    color: AppColor.lightBlack,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 12.h),
            priceWidget(hasDiscount, basePrice, currentPrice),
          ],
        ),
      ),
    );
  }

  Widget priceWidget(
      bool? hasDiscount, String? basePrice, String? currentPrice) {
    bool val = hasDiscount ?? false;
    if (val) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            basePrice.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.red,
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: screen.height / 4),
          ),
          SizedBox(
            width: screen.width * 2,
          ),
          Text(
            currentPrice.toString(),
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(
                color: AppColor.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
          )
        ],
      );
    } else {
      return Text(
        basePrice.toString(),
        textAlign: TextAlign.justify,
        style: GoogleFonts.poppins(
            color: AppColor.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400),
      );
    }
  }
}

class BrandGridItem extends StatelessWidget {
  double width, height;
  String name, imageUrl;
  String brandProductUrl;

  BrandGridItem({
    required this.brandProductUrl,
    required this.width,
    required this.height,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.product,
            arguments: ScreenArguments(data: {
              "url": brandProductUrl,
              "category": name,
              "numberofChildren": 0,
              "subcategoryUrl": "",
            }));
      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height),
            side: BorderSide(color: Colors.grey.shade200, width: width / 6)),
        child: Container(
          padding: EdgeInsets.only(
              left: width, right: width, top: width, bottom: width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: height * 15,
                padding: EdgeInsets.symmetric(horizontal: width * 3),
                child: CachedImage(
                  imageUrl: imageUrl,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: height),
                alignment: Alignment.center,
                child: Text(
                  name.compareTo("null") == 0 ? "No Name" : name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: height * 1.45,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: height),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  double width, height;
  Function onTap;
  Color buttonColor, fontColor;
  String title;
  double? borderRadius;
  bool? showLoader;

  Button(
      {required this.width,
      required this.height,
      required this.onTap,
      this.borderRadius,
      this.showLoader,
      required this.buttonColor,
      required this.fontColor,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
        ),
        onPressed: () {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: fontColor, fontSize: height / 2.7),
            ),
            Visibility(
              visible: showLoader == null ? false : showLoader!,
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
        ));
  }
}

class ProductGridMini extends StatelessWidget {
  double width, height;
  String name, imageUrl, price;
  String id;

  ProductGridMini({
    required this.id,
    required this.width,
    required this.height,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.product_details,
            arguments: ScreenArguments(data: {"productId": id}));
      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height),
            side: BorderSide(color: Colors.grey.shade200, width: width / 6)),
        child: Container(
          padding: EdgeInsets.only(
              left: width, right: width, top: width, bottom: width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 25,
                height: height * 9,
                child: CachedImage(
                  imageUrl: imageUrl,
                ),
              ),
              Container(
                width: width * 25,
                padding: EdgeInsets.symmetric(horizontal: width * 1.5),
                alignment: Alignment.centerLeft,
                child: Text(
                  name.compareTo("null") == 0 ? "No Name" : name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: height * 1.35,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 1.5),
                width: width * 25,
                child: Text(
                  price,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: height * 1.35,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditText extends StatelessWidget {
  String hints;
  double width, height;
  TextEditingController controller;
  bool? isObscure;
  TextInputType? inputType;
  TextInputAction? inputAction;
  double? borderRadius;
  Function? ontap;

  EditText(
      {required this.controller,
      required this.width,
      required this.height,
      required this.hints,
      this.isObscure,
      this.inputType,
      this.borderRadius,
      this.inputAction,
      this.ontap});

  late FocusNode node = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      child: TextFormField(
        controller: controller,
        focusNode: node,
        textInputAction: inputAction ?? TextInputAction.next,
        textAlign: TextAlign.center,
        onTap: () {
          if (ontap != null) {
            ontap!();
            node.unfocus();
          }
        },
        obscureText: isObscure ?? false,
        style: TextStyle(fontSize: height / 2.5),
        keyboardType: inputType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: hints,
          isDense: true,
          hintStyle: TextStyle(color: AppColor.secondary.withOpacity(0.5)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class SellerGridItem extends StatelessWidget {
  String name, imageUrl;
  String sellerId;

  SellerGridItem({
    required this.sellerId,
    required this.name,
    required this.imageUrl,
  });

  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.seller_details,
            arguments: ScreenArguments(data: {"sellerId": sellerId}));
      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screen.height),
            side: BorderSide(
                color: Colors.grey.shade200, width: screen.width / 6)),
        child: Container(
          padding: EdgeInsets.only(
              left: screen.width,
              right: screen.width,
              top: screen.width,
              bottom: screen.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: screen.height * 15,
                padding: EdgeInsets.symmetric(horizontal: screen.width * 3),
                child: CachedImage(
                  imageUrl: imageUrl,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: screen.height),
                alignment: Alignment.center,
                child: Text(
                  name.compareTo("null") == 0 ? "No Name" : name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: screen.height * 1.45,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: screen.height),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerItem extends StatelessWidget {
  String imageUrl;
  String productUrl;

  SellerItem({required this.imageUrl, required this.productUrl});

  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.product,
            arguments: ScreenArguments(data: {
              "url": productUrl,
              "category": "",
              "numberofChildren": 0,
              "subcategoryUrl": "",
            }));
      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screen.height),
            side: BorderSide(
                color: Colors.grey.shade200, width: screen.width / 6)),
        child: Container(
          padding: EdgeInsets.only(
              left: screen.width,
              right: screen.width,
              top: screen.width,
              bottom: screen.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: screen.height * 15,
                padding: EdgeInsets.symmetric(horizontal: screen.width * 3),
                child: CachedImage(
                  imageUrl: imageUrl,
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.symmetric(horizontal: screen.height),
              //   alignment: Alignment.center,
              //   child: Text(
              //     name.compareTo("null") == 0 ? "No Name" : name,
              //     textAlign: TextAlign.left,
              //     overflow: TextOverflow.ellipsis,
              //     maxLines: 2,
              //     style: TextStyle(
              //         color: Colors.black87,
              //         fontSize: screen.height * 1.45,
              //         fontWeight: FontWeight.w400),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewBar extends StatelessWidget {
  double height, width, rating, spacing;
  Color color;
  int numberOfStars;
  String ratingCount;

  ReviewBar(
      {required this.height,
      required this.width,
      required this.spacing,
      required this.rating,
      required this.color,
      required this.ratingCount,
      required this.numberOfStars});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 8 + spacing * 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width * 5 + spacing * 4,
            height: height,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: numberOfStars,
              itemBuilder: (context, index) {
                return Container(
                    padding: EdgeInsets.only(right: spacing),
                    width: width,
                    height: height,
                    child: stars());
              },
            ),
          ),
          Text("( " + ratingCount + " )"),
        ],
      ),
    );
  }

  Widget stars() {
    if (rating >= 1 && rating <= 5) {
      rating = rating - 1.0;
      return Icon(
        Icons.star,
        size: height,
        color: color,
      );
    } else if (rating > 0 && rating < 1) {
      rating = rating - 1.0;
      return Icon(
        Icons.star_half,
        size: height,
        color: color,
      );
    } else {
      return Icon(
        Icons.star_border,
        size: height,
        color: AppColor.primary,
      );
    }
  }
}

class ImageTitleBlock extends StatelessWidget {
  String title;
  double width;
  double height;

  ImageTitleBlock(
      {required this.title, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: height * 10),
        Image(
          width: width * 20,
          height: width * 20,
          image: AssetImage(AppImage.whiteLogo),
        ),
        SizedBox(height: height),
        Container(
          height: height * 5,
          width: width * 70,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: AppColor.primary,
              fontSize: height * 2.5,
              fontFamily: AppFont.Poppins,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class MyText extends StatelessWidget {
  String name, value;

  Color valueColor;
  double? valueFieldWidth;
  double nameFontSize, valueFontSize;

  MyText(
      {required this.name,
      required this.value,
      required this.valueColor,
      required this.nameFontSize,
      this.valueFieldWidth,
      required this.valueFontSize});

  late double width, height;

  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: width * 25,
          height: height * 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height * 3,
                alignment: Alignment.center,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: AppFont.Poppins,
                      color: AppColor.black,
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: height * 3,
                alignment: Alignment.center,
                child: Text(
                  ":",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: AppFont.Poppins,
                      color: AppColor.black,
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
        valueFieldWidth != null
            ? Container(
                height: height * 3,
                width: valueFieldWidth,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: width * 2),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: AppFont.Poppins,
                        color: valueColor,
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            : Container(
                height: height * 3,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: width * 2),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: AppFont.Poppins,
                        color: valueColor,
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
      ],
    );
  }
}

class BrandText extends StatelessWidget {
  String name, value;

  Color valueColor;
  double nameFontSize, valueFontSize;

  BrandText(
      {required this.name,
      required this.value,
      required this.valueColor,
      required this.nameFontSize,
      required this.valueFontSize});

  late double width, height;

  @override
  Widget build(BuildContext context) {
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: width * 16,
          height: height * 3,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: height * 3,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: AppFont.Poppins,
                      color: AppColor.black,
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: height * 3,
                child: Text(
                  " :",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: AppFont.Poppins,
                      color: AppColor.black,
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: height * 3,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: AppFont.Poppins,
                color: valueColor,
                fontSize: valueFontSize,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class PhoneField extends StatelessWidget {
  TextEditingController controller;

  PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: AppColor.secondary, width: 1.w)),
      child: Row(
        children: [
          Container(
            width: 83.w,
            height: 50.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColor.itemBackground,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.r),
                    bottomLeft: Radius.circular(5.r))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImage.flag, width: 30.w, height: 30.h),
                Text(" +88",
                    style: GoogleFonts.roboto(
                        fontSize: 16.sp, fontWeight: FontWeight.w400))
              ],
            ),
          ),
          Container(
            width: 272.w,
            height: 50.h,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5.w),
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                color: AppColor.secondary,
              )),
            ),
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                  fontSize: 16.sp, fontWeight: FontWeight.w400),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                isDense: true,
                hintStyle:
                    TextStyle(color: AppColor.secondary.withOpacity(0.5)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OtpInput extends StatefulWidget {
  TextEditingController controller;
  Function onChnaged;
  bool isFocused;

  OtpInput(
      {required this.controller,
      required this.isFocused,
      required this.onChnaged});

  @override
  State<OtpInput> createState() => _OtpInputState(isFocused);
}

class _OtpInputState extends State<OtpInput> {
  bool hasFocus = false;

  _OtpInputState(bool isFocused) {
    hasFocus = isFocused;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: AppColor.secondary)),
      child: TextFormField(
        autofocus: hasFocus,
        controller: widget.controller,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        onTap: () {
          setState(() {
            hasFocus = true;
          });
        },
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else {
            widget.onChnaged(value);
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: GoogleFonts.roboto(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 24.sp),
      ),
    );
  }
}
