// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_models/category_response.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_drawer.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_statusbar.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/category_back.dart';
import 'package:monarch_mart/categories/category_provider.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  String url;
  Category({required this.url});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late AppScreen screen;
  var searchController = TextEditingController();
  late CategoryProvider provider;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    provider = Provider.of<CategoryProvider>(context, listen: false);
    Statusbar.lightIcon();

    provider.init(widget.url);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.primary,
      resizeToAvoidBottomInset: false,
      appBar: Myappbar(context).appbar(
          isFromHome: false,
          isCategory: true,
          title: "All Categories",
          ontap: () {
            scaffoldKey.currentState?.openDrawer();
          }),
      drawer: AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () async {
            provider.init(widget.url);
          },
          child: Container(
              color: AppColor.white,
              width: double.infinity,
              height: double.infinity,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Categoryback(
                    child: Column(
                      children: [
                        searchBox(),
                        Consumer<CategoryProvider>(
                          builder: (context, provider, child) {
                            if (provider.response != null) {
                              if (provider.response!.data!.isNotEmpty) {
                                return GridView.builder(
                                  padding: EdgeInsets.only(
                                      left: screen.width * 5,
                                      right: screen.width * 5,
                                      bottom: screen.height * 5),
                                  shrinkWrap: true,
                                  itemCount: provider.response!.data!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: screen.width * 1.5,
                                          mainAxisSpacing: screen.height,
                                          crossAxisCount: 4,
                                          childAspectRatio:
                                              ((screen.width * 23) /
                                                  (screen.height * 15))),
                                  itemBuilder: (context, index) {
                                    return singleItem(
                                        provider.response!, index);
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text("Data not Available"),
                                );
                              }
                            } else {
                              return GridView.builder(
                                padding: EdgeInsets.only(
                                    left: screen.width * 5,
                                    right: screen.width * 5,
                                    bottom: screen.height * 5),
                                shrinkWrap: true,
                                itemCount: 16,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: screen.width * 1.5,
                                  mainAxisSpacing: screen.height,
                                  crossAxisCount: 4,
                                ),
                                itemBuilder: (context, index) {
                                  return AppShimer(
                                      height: screen.height * 10,
                                      width: screen.width * 15);
                                },
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ))),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }

  Widget searchBox() {
    return Container(
      width: double.infinity,
      height: screen.height * 20,
      padding: EdgeInsets.only(top: screen.height * 5),
      alignment: Alignment.topCenter,
      child: EditText(
          ontap: () {
            Navigator.pushNamed(context, AppRoute.filteredProduct,
                arguments:
                    ScreenArguments(data: {"category": AppString.Product}));
          },
          controller: searchController,
          width: screen.width * 90,
          height: screen.height * 6,
          hints: "Search Category"),
    );
  }

  Widget singleItem(CategoryResponse? response, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.product,
            arguments: ScreenArguments(data: {
              "url": response?.data?[index].links?.products,
              "category": response?.data?[index].name,
              "numberofChildren": response?.data?[index].numberOfChildren,
              "subcategoryUrl": response?.data?[index].links?.subCategories
            }));
      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screen.height),
            side: BorderSide(
                color: Colors.grey.shade200, width: screen.width / 6)),
        child: Container(
          width: screen.width * 20,
          padding: EdgeInsets.symmetric(vertical: screen.width),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screen.height),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: screen.width * 15,
                  height: screen.width * 15,
                  padding: EdgeInsets.only(
                      top: screen.height,
                      left: screen.width,
                      right: screen.width),
                  child: CachedImage(
                    imageUrl: response!.data![index].banner.toString(),
                  )),
              Container(
                width: screen.width * 20,
                padding: EdgeInsets.only(top: screen.height / 2),
                alignment: Alignment.center,
                child: Text(
                  response.data![index].name.toString(),
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
