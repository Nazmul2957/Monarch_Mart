// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/customWidget.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/product/product_details/components/disclaimer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/availablility_brand_sku.dart';
import 'components/product_name_review.dart';
import 'components/product_slider.dart';
import 'components/seller_name_share.dart';
import 'components/tabs.dart';
import 'components/top_selling.dart';
import 'components/variation_window.dart';
import 'product_details_provider.dart';

class ProductDetails extends StatelessWidget {
  String productId;

  ProductDetails({
    required this.productId,
  });

  late ProductDetailsProvider presenter;
  late BuildContext context;
  late AppScreen screen;

  Future _onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    this.context = context;
    screen = AppScreen(context);
    print(productId);
    print("product details page");
    presenter = Provider.of<ProductDetailsProvider>(context, listen: false);
    if (!presenter.isInitialize) {
      presenter.initializer(productId: productId, context: context);
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ProductSlider(
                        presenter: presenter,
                        width: screen.width,
                        height: screen.height),
                    ProdNameReview(
                        presenter: presenter,
                        height: screen.height,
                        width: screen.width),
                    AvailabilityBrandSku(),
                    SizedBox(height: screen.height * 1.5),
                    VariationWindow(
                        presenter: presenter,
                        width: screen.width,
                        height: screen.height),
                    SizedBox(height: screen.height * 1.5),
                    SellerName(presenter: presenter),
                    SizedBox(height: screen.height * 1.5),
                    Tabs(provider: presenter),
                    SizedBox(height: screen.height),
                    Disclaimer(),
                    SizedBox(height: screen.height),
                    TopSellingProducts(
                        presenter: presenter,
                        width: screen.width,
                        height: screen.height),
                    SizedBox(height: screen.height),
                  ],
                ),
              ),
              Myappbar(context).appbarProductDetails(presenter),
            ],
          ),
        ),
        bottomNavigationBar: ListView(
          shrinkWrap: true,
          children: [
            bottomButtons(),
            AppBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(screen.width * 45, screen.height * 6.5),
              primary: Color(0xFFdd9f08),
              elevation: 1,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screen.height),
              ),
              textStyle: TextStyle(
                fontSize: screen.height * 2.5,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              String? accsess = preferences.getString(AppConstant.ACCESS_TOKEN);
              if (accsess != null) {
                if (presenter.stock > 0) {
                  if (presenter.quantity > 0) {
                    presenter.addProductToCart(productId: productId);
                  } else {
                    toast("Atleast 1 item must Added");
                  }
                } else {
                  toast("Not enough item available");
                }
              } else {
                toast("Login First");
                Navigator.pushNamed(context, AppRoute.login);
              }
            },
            child: Obx(() => buildButtonTextLoader(
                  btnText: "Add To Cart",
                  showLoader: presenter.loaderController.cartLoader.value &&
                      !presenter.loaderController.isBuyNow.value,
                ))),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(screen.width * 45, screen.height * 6.5),
              primary: AppColor.primary,
              elevation: 0.5,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screen.height),
              ),
              textStyle: TextStyle(
                fontSize: screen.height * 2.5,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              String? accsess = preferences.getString(AppConstant.ACCESS_TOKEN);
              if (accsess != null) {
                if (presenter.stock > 0) {
                  if (presenter.quantity > 0) {
                    presenter.addProductToCart(
                        productId: productId, isBuyNow: true);
                  } else {
                    toast("Atleast 1 item Should Order");
                  }
                } else {
                  toast("Not enough item available");
                }
              } else {
                toast("Login First");
                Navigator.pushNamed(context, AppRoute.login);
              }
            },
            child: Obx(() => buildButtonTextLoader(
                  btnText: "Buy Now",
                  showLoader: presenter.loaderController.cartLoader.value &&
                      presenter.loaderController.isBuyNow.value,
                ))),
      ],
    );
  }

  Widget otherOptions(String title, int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            switch (index) {
              case 1:
                break;
              case 2:
                break;
              case 3:
                break;
              case 4:
                break;
              default:
            }
          },
          child: Container(
            width: screen.width * 90,
            height: screen.height * 5,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: screen.height * 1.7,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    )),
                Icon(
                  Icons.add,
                  color: Colors.green,
                  size: screen.height * 3,
                )
              ],
            ),
          ),
        ),
        Divider(height: screen.height / 2)
      ],
    );
  }

  void toast(String message) {
    Toast.createToast(
        context: context, message: message, duration: Duration(seconds: 1));
  }
}
