import 'package:flutter/material.dart';
import 'package:monarch_mart/address/address_provider.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/filtered_products/filter_provider.dart';
import 'package:monarch_mart/product/product_details/product_details_provider.dart';
import 'package:monarch_mart/product/product_provider.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';

class Myappbar {
  late AppScreen screen;
  late BuildContext context;
  late FocusNode node;
  late double width, height, statusbar;
  Myappbar(BuildContext context) {
    this.context = context;
    node = new FocusNode();
    screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    statusbar = screen.statusbar;
  }

  PreferredSize appbar(
      {required Function ontap,
      required bool isFromHome,
      bool? isCategory,
      String? title}) {
    return PreferredSize(
      preferredSize: Size(screen.width * 90, screen.height * 7),
      child: Container(
        width: screen.width * 100,
        padding: EdgeInsets.only(
            left: screen.width * 5,
            right: screen.width * 5,
            top: screen.statusbar),
        child: Container(
          width: screen.width * 90,
          padding: EdgeInsets.symmetric(horizontal: screen.width * 2),
          decoration: isFromHome
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(screen.height),
                  color: AppColor.white,
                  boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: screen.width / 5,
                          blurRadius: screen.height,
                          offset: Offset(1, 1) // changes position of shadow
                          )
                    ])
              : BoxDecoration(
                  color:
                      isCategory == null ? AppColor.white : AppColor.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  ontap();
                },
                child: Container(
                  width: screen.width * 10,
                  child: Icon(Icons.menu,
                      color: isCategory == null
                          ? AppColor.lightBlack
                          : AppColor.white,
                      size: screen.height * 3.5),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: screen.width * 60,
                child: Text(
                  title ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screen.height * 3,
                      color: isCategory == null
                          ? AppColor.primary
                          : AppColor.white),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.filteredProduct,
                      arguments: ScreenArguments(
                          data: {"category": AppString.Product}));
                },
                child: Container(
                  width: screen.width * 10,
                  child: Icon(Icons.search,
                      color: isCategory == null
                          ? AppColor.secondary
                          : AppColor.white,
                      size: screen.height * 3.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize appBarProduct(ProductProvider provider, String categoryName) {
    TextEditingController controller =
        new TextEditingController(text: provider.searchText);
    return PreferredSize(
      preferredSize: Size(screen.width * 100, screen.height * 8),
      child: Container(
        color: Colors.white,
        width: screen.width * 90,
        height: screen.height * 8,
        padding: EdgeInsets.only(
            left: screen.width * 5,
            right: screen.width * 5,
            top: screen.statusbar),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            backButton(),
            searchBoxProduct(controller, categoryName, provider),
            InkWell(
              onTap: () {
                node.unfocus();
                provider.setSearchText(controller.text);
              },
              child: Container(
                width: screen.width * 10,
                child: Icon(
                  Icons.search,
                  size: screen.height * 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBoxProduct(controller, String hints, ProductProvider presenter) {
    controller.text = presenter.searchText;
    return Container(
      width: screen.width * 70,
      height: screen.height * 5,
      padding: EdgeInsets.only(left: screen.width * 3),
      alignment: Alignment.centerLeft,
      child: TextFormField(
          textAlign: TextAlign.left,
          controller: controller,
          focusNode: node,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.8),
            fontFamily: "Poppins",
            fontSize: screen.height * 1.7,
          ),
          onChanged: (text) {
            if (text.length == 0) {
              node.unfocus();
              presenter.setSearchText("");
            }
          },
          onFieldSubmitted: (text) {
            controller.text = text;
            presenter.setSearchText(text);
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search products from: " + hints,
            hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
            border: InputBorder.none,
          )),
    );
  }

  Widget appbarProductDetails(ProductDetailsProvider provider) {
    return Container(
      width: screen.width * 100,
      height: screen.height * 8,
      padding:
          EdgeInsets.only(left: screen.width * 2.5, right: screen.width * 2.5),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(),
          Container(
            width: screen.width * 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: screen.width * 10,
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () {
                          if (Provider.of<AppProvider>(context, listen: false)
                                  .accessToken !=
                              null) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, AppRoute.cart, (route) => false);
                          } else {
                            Toast.createToast(
                              context: context,
                              message: "Login First!!!",
                              duration: Duration(seconds: 1),
                            );
                            Navigator.pushNamed(context, AppRoute.login);
                          }
                        },
                        child: cartIcon())),
                GestureDetector(
                  onTap: () {
                    if (Provider.of<AppProvider>(context, listen: false)
                            .accessToken !=
                        null) {
                      provider.changeWishList(productId: provider.productId);
                    } else {
                      Toast.createToast(
                        context: context,
                        message: "Login First!!!",
                        duration: Duration(seconds: 1),
                      );
                      Navigator.pushNamed(context, AppRoute.login);
                    }
                  },
                  child: Container(
                      width: width * 10,
                      alignment: Alignment.topCenter,
                      child: Consumer<ProductDetailsProvider>(
                          builder: (context, ob, child) => Icon(
                                ob.isInWishList
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: height * 3,
                                color: AppColor.primary,
                              ))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cartIcon() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: screen.width * 10,
          alignment: Alignment.topCenter,
          child: SizedBox(
              height: screen.height * 3,
              child: Image(
                  image: AssetImage(AppImage.shopping_cart),
                  color: AppColor.primary)),
        ),
        Consumer<AppProvider>(
          builder: (context, provider, child) {
            return Positioned(
              right: screen.width,
              child: provider.totalCartProducts != 0
                  ? Container(
                      padding: EdgeInsets.all(screen.width),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColor.primary),
                      child: Text(
                        provider.totalCartProducts.toString(),
                        style: TextStyle(
                            fontSize: screen.height * 1.5, color: Colors.white),
                      ))
                  : Container(),
            );
          },
        ),
      ],
    );
  }

  PreferredSize appBarCommon({
    required String title,
    Widget? locationIcon,
  }) {
    return PreferredSize(
      preferredSize: Size(screen.width * 100, screen.height * 8),
      child: Container(
        color: Colors.white,
        width: screen.width * 95,
        height: screen.height * 8,
        padding: EdgeInsets.only(
            left: screen.width * 2.5,
            right: screen.width * 2.5,
            top: screen.statusbar),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            backButton(),
            Container(
              alignment: Alignment.center,
              width: screen.width * 70,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screen.height * 2.2,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            locationIcon == null
                ? SizedBox(width: screen.width * 10)
                : locationIcon,
          ],
        ),
      ),
    );
  }

  PreferredSize appBarFliter(FilterProvider presenter) {
    TextEditingController controller = new TextEditingController();
    return PreferredSize(
      preferredSize: Size(screen.width * 100, screen.height * 8),
      child: Container(
        color: Colors.white,
        width: screen.width * 95,
        height: screen.height * 12,
        padding: EdgeInsets.only(
            left: screen.width * 2.5,
            right: screen.width * 2.5,
            top: screen.statusbar),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            backButton(),
            searchBoxItems(controller, presenter),
            InkWell(
              onTap: () {
                node.unfocus();
                presenter.setSearchText(
                    controller.text, presenter.categoryIndex!);
              },
              child: Container(
                width: screen.width * 10,
                child: Icon(
                  Icons.search,
                  size: screen.height * 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBoxItems(controller, FilterProvider presenter) {
    controller.text = presenter.searchText;
    return Container(
      width: screen.width * 70,
      height: screen.height * 10,
      padding: EdgeInsets.only(left: screen.width * 3),
      alignment: Alignment.centerLeft,
      child: TextFormField(
          textAlign: TextAlign.left,
          controller: controller,
          focusNode: node,
          onChanged: (text) {
            if (text.length == 0) {
              node.unfocus();
              presenter.setSearchText("", presenter.categoryIndex!);
            }
          },
          onFieldSubmitted: (text) {
            presenter.setSearchText(text, presenter.categoryIndex!);
          },
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.8),
            fontFamily: "Poppins",
            fontSize: screen.height * 2,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search here...",
            hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
            border: InputBorder.none,
          )),
    );
  }

  Widget backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: screen.width * 10,
        child: Icon(
          Icons.arrow_back_ios_new,
          size: screen.height * 3,
        ),
      ),
    );
  }

  PreferredSize appBarShipping() {
    return PreferredSize(
      preferredSize: Size(width * 100, height * 8),
      child: Container(
        color: Colors.white,
        width: width * 95,
        height: height * 8,
        padding: EdgeInsets.only(
            left: width * 2.5, right: width * 2.5, top: statusbar),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            backButton(),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: width * 3),
                child: Consumer<AddressProvider>(
                  builder: (context, ob, child) => Text(
                    "Shipping Cost: " + ob.shippingCostString.toString(),
                    style: TextStyle(
                      fontSize: height * 1.8,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: width * 10)
          ],
        ),
      ),
    );
  }

  PreferredSize appBarAllOffer(
      {required String title,
      Widget? locationIcon,
      bool? isNotFromNavigation}) {
    return PreferredSize(
      preferredSize: Size(screen.width * 100, screen.height * 8),
      child: Container(
        color: Colors.white,
        width: screen.width * 95,
        height: screen.height * 8,
        padding: EdgeInsets.only(
            left: screen.width * 2.5,
            right: screen.width * 2.5,
            top: screen.statusbar),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: screen.width * 10,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: screen.height * 3,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: screen.width * 70,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screen.height * 2.2,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            locationIcon == null
                ? SizedBox(width: screen.width * 10)
                : locationIcon,
          ],
        ),
      ),
    );
  }
}
