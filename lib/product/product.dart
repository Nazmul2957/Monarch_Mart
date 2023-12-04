// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/product_response.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/loading_progress.dart';
import 'package:monarch_mart/product/product_provider.dart';
import 'package:provider/provider.dart';

class Product extends StatelessWidget {
  String url, categoryName;
  String subcategoryUrl;
  int numberOfChildren;

  Product(
      {required this.url,
      required this.categoryName,
      required this.subcategoryUrl,
      required this.numberOfChildren});

  late ProductProvider provider;
  ScrollController productScrollController = ScrollController();
  late BuildContext context;

  late AppScreen screen;

  initiallizer() {
    productScrollController.addListener(() {
      if (productScrollController.position.pixels ==
          productScrollController.position.maxScrollExtent) {
        try {
          if (provider.page < provider.response!.meta!.lastPage) {
            LoadingProgrss.showProgress(context);
            provider.nextProductPage();
          } else {
            toast();
          }
        } catch (e) {}
      }
    });
  }

  void toast() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Container(
        height: screen.height * 4.5,
        child: Center(
          child: Text(
            "No More Data to load",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    print("test printsss");
    print(url);
    screen = AppScreen(context);
    this.context = context;
    provider = Provider.of<ProductProvider>(context, listen: false);
    if (provider.isnotInitialized) {
      provider.init(url: url, subCategoryUrl: subcategoryUrl);
      initiallizer();
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Myappbar(context).appBarProduct(provider, categoryName),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: screen.width * 2.5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                numberOfChildren != 0 ? subCategoryBlcok() : Container(),
                Consumer<ProductProvider>(builder: (context, ob, child) {
                  if (ob.response != null) {
                    return gridItems(ob.response);
                  } else {
                    return shimmer();
                  }
                }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  Widget subCategoryBlcok() {
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      if (provider.categoryResponse != null) {
        return Column(
          children: [
            SizedBox(height: screen.height),
            Container(
                width: screen.width * 100,
                padding: EdgeInsets.only(left: screen.width * 5),
                alignment: Alignment.centerLeft,
                child: Header(title: categoryName)),
            SizedBox(height: screen.height),
            Container(
              width: screen.width * 100,
              height: screen.height * 15,
              padding: EdgeInsets.symmetric(
                horizontal: screen.width * 5,
              ),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categoryResponse?.data?.length,
                  itemBuilder: (context, index) {
                    String imageUrl =
                        provider.categoryResponse!.data![index].icon.toString();

                    String title =
                        provider.categoryResponse!.data![index].name.toString();

                    return SubCategoryItem(
                        imageUrl: imageUrl,
                        borderColor: provider.currentOption[index]
                            ? AppColor.primary
                            : Colors.transparent,
                        title: title,
                        ontap: () {
                          provider.setCurrentOption(index);

                          if (provider.categoryResponse?.data?[index]
                                  .numberOfChildren ==
                              0) {
                            provider.getCategoryProducts(
                                categoryUrl: provider.categoryResponse!
                                    .data![index].links!.products
                                    .toString());
                          } else {
                            Navigator.pushNamed(context, AppRoute.product,
                                arguments: ScreenArguments(data: {
                                  "url": provider.categoryResponse?.data?[index]
                                      .links?.products,
                                  "category": provider
                                      .categoryResponse?.data?[index].name,
                                  "numberofChildren": provider.categoryResponse
                                      ?.data?[index].numberOfChildren,
                                  "subcategoryUrl": provider.categoryResponse
                                      ?.data?[index].links?.subCategories
                                }));
                          }
                        });
                  }),
            ),
            SizedBox(
              height: screen.height * 1.5,
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }

  Widget gridItems(ProductResponse? response) {
    return response!.data!.length == 0
        ? Center(
            child: Text("No data available"),
          )
        : Container(
            height: numberOfChildren == 0
                ? screen.height * 88.5
                : screen.height * 65.5,
            child: GridView.builder(
              padding:
                  EdgeInsets.fromLTRB(screen.width * 5, 0, screen.width * 5, 0),
              itemCount: response.data!.length,
              controller: productScrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: ((188.w) / (300.h))),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ProductItem(
                  currentPrice: response.data![index].currentPrice,
                  discount: response.data![index].discount.toString() + " %",
                  hasDiscount: response.data![index].hasDiscount,
                  productId: response.data![index].id.toString(),
                  productTitle: response.data![index].name.toString(),
                  imageUrl: response.data![index].thumbnailImage.toString(),
                  basePrice: response.data![index].basePrice.toString(),
                  addToCart: () {},
                );
              },
            ),
          );
  }

  Widget shimmer() {
    return Container(
      height:
          numberOfChildren == 0 ? screen.height * 88.5 : screen.height * 65.5,
      child: GridView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: screen.width * 2.5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: screen.width * 2,
            mainAxisSpacing: screen.height * 1.5,
            childAspectRatio: ((screen.width * 40) / (screen.height * 35))),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AppShimer(
            height: screen.height * 10,
            width: screen.width * 40,
            borderRadius: screen.height,
          );
        },
      ),
    );
  }
}
