import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_drawer.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_statusbar.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/home/components/carousel_home.dart';
import 'package:monarch_mart/home/components/dashboard_options.dart';
import 'package:monarch_mart/home/components/featured_product.dart';
import 'package:monarch_mart/home/components/first_banner_block.dart';
import 'package:monarch_mart/home/components/on_sale_products.dart';
import 'package:monarch_mart/home/components/product_lists.dart';
import 'package:monarch_mart/home/components/second_banner_block.dart';
import 'package:monarch_mart/home/components/top_category_option.dart';
import 'package:monarch_mart/home/home_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppScreen screen;
  late HomeProvider provider;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Statusbar.darkIcon();
    screen = AppScreen(context);

    provider = Provider.of<HomeProvider>(context, listen: false);
    if (provider.isnotInitialized) {
      provider.init();
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: Myappbar(context).appbar(
          isFromHome: true,
          ontap: () {
            scaffoldKey.currentState?.openDrawer();
          }),
      drawer: AppDrawer(),
      backgroundColor: AppColor.white,
      body: RefreshIndicator(
        onRefresh: () async {
          provider.refresh();
        },
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: screen.height),
          children: [
            CarouselHome(),
            SizedBox(height: screen.height),
            DashboardOptions(),
            SizedBox(height: screen.height * 2),
            TopCategoryOption(),
            SizedBox(height: 15.h),
            FisrstBannerBlock(),
            SizedBox(height: 15.h),
            FeaturedProduct(),
            SizedBox(height: 24.h),
            SecondBannerBlock(),
            SizedBox(height: 24.h),
            On_Sale_Products(),
            SizedBox(height: 24.h),
            ProductLists(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }
}
