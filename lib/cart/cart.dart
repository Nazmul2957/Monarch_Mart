import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_font.dart';
import 'package:monarch_mart/app_models/cart_models.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_drawer.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_statusbar.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/customWidget.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late AppScreen screen;
  late double width, height;
  late CartProvider provider;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CartProvider>(context, listen: false);
    Statusbar.darkIcon();
    screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    if (!provider.isInitialize) {
      provider.init(context: context);
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.white,
      appBar: Myappbar(context).appbar(
          title: "Your Cart",
          isFromHome: false,
          ontap: () {
            scaffoldKey.currentState?.openDrawer();
          }),
      drawer: AppDrawer(),
      body: Consumer<CartProvider>(
        builder: (context, ob, child) {
          if (ob.cartLists != null) {
            if (ob.cartModel.isNotEmpty) {
              return RefreshIndicator(
                  color: AppColor.secondary,
                  backgroundColor: Colors.white,
                  onRefresh: () async {},
                  child: ListView.builder(
                      itemCount: ob.cartModel.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: height / 2, horizontal: width * 2.5),
                            child: ob.cartModel[index].itemsList!.length == 0
                                ? Container()
                                : subitemList(
                                    ob.cartModel[index].itemsList, index));
                      }));
            } else {
              return Center(child: Text("No items available"));
            }
          } else {
            return shimer();
          }
        },
      ),
      bottomNavigationBar: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(width: width * 100, child: bottomOptions()),
          AppBottomNavigation()
        ],
      ),
    );
  }

  Widget subitemList(List<Model>? itemsList, int mainIndex) {
    return ListView.builder(
      itemCount: itemsList!.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, subIndex) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: height / 2),
          child: singleItem(itemsList[subIndex], mainIndex, subIndex),
        );
      },
    );
  }

  Widget singleItem(Model model, int mainIndex, subIndex) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height),
        color: AppColor.lightWhite.withOpacity(0.5),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: screen.width * 2, vertical: screen.height),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   alignment: Alignment.topCenter,
          //   width: screen.width * 5,
          //   height: screen.width * 5,
          //   child: SizedBox(
          //       width: screen.width * 5,
          //       child: Checkbox(value: false, onChanged: (v) {})),
          // ),
          detailsRow(model, mainIndex, subIndex),
          Container(
            width: screen.width * 30,
            height: screen.width * 30,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: height,
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(1, 1))
            ], borderRadius: BorderRadius.circular(screen.height * 2)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height * 2),
              child: CachedImage(
                imageUrl: model.productThumbnailImage.toString(),
                boxFit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget detailsRow(Model listItem, int mainIndex, subIndex) {
    return Container(
      alignment: Alignment.centerLeft,
      width: screen.width * 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          productName(listItem.productName.toString()),
          //  productId(listItem.productId.toString()),
          price(listItem.price.toString()),
          quantityDelete(listItem, mainIndex, subIndex)
        ],
      ),
    );
  }

  Widget productName(String title) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.black,
          fontFamily: AppFont.Poppins,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500),
    );
  }

  Widget productId(String id) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screen.height),
      child: Text(
        id,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColor.lightBlack,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget price(String price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screen.height),
      child: Text(
        "\u09F3 " + price,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColor.primary,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget quantityDelete(Model listItem, int mainIndex, subindex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            provider.incrementQuantity(mainIndex, subindex);
          },
          child: Container(
            width: screen.width * 7,
            height: screen.width * 7,
            decoration: BoxDecoration(
              color: AppColor.lightWhite,
              borderRadius: BorderRadius.circular(screen.height / 2),
            ),
            child: Icon(Icons.add),
          ),
        ),
        Container(
          width: screen.width * 7,
          height: screen.width * 7,
          alignment: Alignment.center,
          child: Text(listItem.quantity.toString(),
              style: TextStyle(
                  color: AppColor.primary,
                  fontSize: screen.height * 2,
                  fontWeight: FontWeight.bold)),
        ),
        InkWell(
          onTap: () {
            provider.decrementQuantity(mainIndex, subindex);
          },
          child: Container(
            width: screen.width * 7,
            height: screen.width * 7,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.lightWhite,
              borderRadius: BorderRadius.circular(screen.height / 2),
            ),
            child: Icon(Icons.remove),
          ),
        ),
        SizedBox(width: screen.width),
        InkWell(
          onTap: () {
            provider.deleteItem(listItem, mainIndex, subindex);
          },
          child: Container(
            width: screen.width * 7,
            height: screen.width * 7,
            decoration: BoxDecoration(
              color: AppColor.lightWhite,
              border:
                  Border.all(color: AppColor.primary, width: screen.width / 6),
              borderRadius: BorderRadius.circular(screen.height / 2),
            ),
            child: Icon(
              Icons.delete,
              color: AppColor.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget shimer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: height),
          child: AppShimer(
            width: width * 90,
            height: height * 18,
          )),
    );
  }

  Widget bottomOptions() {
    return SizedBox(
        width: width * 100,
        height: height * 14,
        child: Column(
          children: [
            buildCustomDecoration(
              width: width * 90,
              height: height * 4,
              padding: EdgeInsets.symmetric(horizontal: width * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                color: AppColor.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: height * 1.8,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, ob, child) => Text(
                      ob.totalCost == 0
                          ? "..."
                          : ob.currencySymbol.toString() +
                              " " +
                              ob.totalCost.toString(),
                      style: TextStyle(
                        fontSize: height * 1.8,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height / 2),
            bottomButtons(),
            SizedBox(height: height),
          ],
        ));
  }

  Widget bottomButtons() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width * 90, height * 5),
        primary: AppColor.primary,
        elevation: 0.5,
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        textStyle: TextStyle(
          fontSize: height * 2,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
        provider.processCart();
      },
      child: Obx(
        () => buildButtonTextLoader(
            btnText: "Proceed to Order",
            showLoader: provider.loaderController.orderLoader.value),
      ),
    );
  }
}
