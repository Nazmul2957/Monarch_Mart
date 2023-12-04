import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_models/order_details_response.dart';
import 'package:monarch_mart/app_models/ordered_product_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsProvider extends ChangeNotifier {
  OrderDetailsResponse? response;
  OrderedProductResponse? productResponse;
  String? userId, accessToken, ownerId, orderId;
  CommonResponse? commonResponse;
  late SharedPreferences preferences;
  bool initialzed = false;

  init({required String orderId}) {
    initialzed = true;
    this.orderId = orderId;
    getUserinfo().then((list) {
      this.accessToken = list[0];
      this.userId = list[1];
    });
    getOrderDetails(orderId: orderId);
    getOrderedItems(orderId: orderId);
  }

  Future getOrderDetails({required String orderId}) async {
    var caller =
        await MyClient.get(endpoint: "/purchase-history-details/" + orderId);

    if (caller.statusCode == 200) {
      response = OrderDetailsResponse.fromJson(jsonDecode(caller.body));
      print(caller.body);
      notifyListeners();
    }
  }

  Future getOrderedItems({required String orderId}) async {
    var caller =
        await MyClient.get(endpoint: "/purchase-history-items/" + orderId);

    if (caller.statusCode == 200) {
      productResponse =
          OrderedProductResponse.fromJson(jsonDecode(caller.body));
      notifyListeners();
    }
  }

  Future getUserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));
    return holder;
  }
}
