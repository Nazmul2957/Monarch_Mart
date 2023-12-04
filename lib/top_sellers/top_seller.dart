// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_models/best_seller_response.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/top_sellers/top_seller_provider.dart';
import 'package:provider/provider.dart';

class TopSellers extends StatelessWidget {
  late TopSellerProvider presenter;
  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    presenter = Provider.of<TopSellerProvider>(context, listen: false);
    presenter.getTopSellingProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Myappbar(context).appBarCommon(title: "Best Sellers"),
      body: RefreshIndicator(
        onRefresh: () async {
          presenter.refresh();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screen.width * 2.5),
          child: Consumer<TopSellerProvider>(builder: (context, ob, child) {
            if (ob.response != null) {
              return gridItems(ob.response);
            } else {
              return shimmer();
            }
          }),
        ),
      ),
    );
  }

  Widget gridItems(BestSellerResponse? response) {
    return GridView.builder(
      itemCount: response!.data!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: screen.width * 2,
          mainAxisSpacing: screen.width * 2,
          childAspectRatio: 1),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SellerItem(
            imageUrl: (response.data![index].photo ?? ""),
            productUrl: response.data?[index].url.toString() ?? "");
      },
    );
  }

  Widget shimmer() {
    return GridView.builder(
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: screen.width * 2.5,
          mainAxisSpacing: screen.width * 2.5,
          childAspectRatio: 1),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return AppShimer(height: screen.height * 10, width: screen.width * 10);
      },
    );
  }
}
