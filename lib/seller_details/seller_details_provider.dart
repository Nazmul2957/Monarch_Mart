// ignore_for_file: must_call_super

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/product_response.dart';
import 'package:monarch_mart/app_models/seller_details_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';

class SellerDetailsProvider extends ChangeNotifier {
  SellerDetailsResponse? detailsResponse;
  ProductResponse? featuredResponse, newArrivalResponse, topResponse;

  bool isInitialized = false;
  late BuildContext context;

  init({required BuildContext context, required String sellerId}) {
    this.context = context;
    isInitialized = true;
    getSellerInfo(sellerId: sellerId);
    getTopFromSeller(sellerId: sellerId);
    getFeaturedFromSeller(sellerId: sellerId);
    getNewArraivalFromSeller(sellerId: sellerId);
  }

  Future<int> getSellerInfo({required sellerId}) async {
    try {
      var caller =
          await MyClient.get(endpoint: "/shops/details/" + sellerId.toString());
      detailsResponse = SellerDetailsResponse.fromJson(jsonDecode(caller.body));
      notifyListeners();
      if (detailsResponse!.success!) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> getTopFromSeller({required sellerId}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/shops/products/top/" + sellerId.toString());
      topResponse = ProductResponse.fromJson(jsonDecode(caller.body));
      notifyListeners();
      if (detailsResponse!.success!) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> getNewArraivalFromSeller({required sellerId}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/shops/products/new/" + sellerId.toString());

      newArrivalResponse = ProductResponse.fromJson(jsonDecode(caller.body));
      notifyListeners();
      if (detailsResponse!.success!) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> getFeaturedFromSeller({required sellerId}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/shops/products/featured/" + sellerId.toString());
      featuredResponse = ProductResponse.fromJson(jsonDecode(caller.body));
      notifyListeners();
      if (detailsResponse!.success!) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  @override
  void dispose() {}
}
