// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/seller_details/seller_details_provider.dart';
import 'package:provider/provider.dart';

import 'components/new_arrivals.dart';
import 'components/seller_featured.dart';
import 'components/seller_logo_name_review.dart';
import 'components/seller_slider.dart';
import 'components/seller_to_selling.dart';

class SellerDetails extends StatelessWidget {
  String sellerId;
  SellerDetails({required this.sellerId});

  late SellerDetailsProvider provider;
  late BuildContext context;
  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    screen = AppScreen(context);

    provider = Provider.of<SellerDetailsProvider>(context, listen: false);
    if (!provider.isInitialized) {
      provider.init(context: context, sellerId: sellerId);
    }
    print("Seller Id: " + sellerId);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: Myappbar(context).appBarCommon(
            title: "Seller Details", locationIcon: locationIconWidget()),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
          children: [
            LogoNameReview(),
            SellerSlider(),
            NewArrivals(provider: provider),
            SellerToSelling(
              presenter: provider,
            ),
            SellerFeatured(provider: provider),
          ],
        ),
        bottomNavigationBar: ListView(
          shrinkWrap: true,
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: screen.width * 5, vertical: screen.width),
            //   child: ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         fixedSize: Size(screen.width * 90, screen.height * 6),
            //       ),
            //       child: Text("View All Products From This Seller")),
            // ),
            AppBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget locationIconWidget() {
    return InkWell(
      onTap: () {
        if (provider.detailsResponse != null) {
          showAddress();
        } else {
          Toast.createToast(
              context: context,
              message: "No address available",
              duration: Duration(seconds: 1));
        }
      },
      child: Container(
        width: screen.width * 10,
        height: screen.width * 10,
        alignment: Alignment.center,
        child: Icon(Icons.location_on,
            size: screen.height * 3, color: Colors.green),
      ),
    );
  }

  void showAddress() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: screen.width * 80,
              height: screen.height * 20,
              alignment: Alignment.center,
              child: Text(
                provider.detailsResponse!.data![0].address.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screen.height * 1.7, color: Colors.black87),
              ),
            ),
          );
        });
  }
}
