import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/order_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/dropdown_bar.dart';

class OrderProvider extends ChangeNotifier {
  Options? selecetedPayment = Options("", "All"),
      selectedDelivary = Options("", "All");
  late SharedPreferences preferences;
  bool isInitialize = false;
  String? userId;
  OrderResponse? orderResponse;
  int page = 1;

  init() {
    isInitialize = true;
    getUserId().then((userId) {
      this.userId = userId;
      getOrderList();
    });
  }

  void nextPage() {
    page++;
    getOrderList(
      page: page,
      deliveryStatus: selectedDelivary!.optionKey,
      paymentStatus: selecetedPayment!.optionKey,
    );
  }

  void refresh() {
    orderResponse = null;
    page = 1;
    notifyListeners();
    getOrderList(
      deliveryStatus: selectedDelivary!.optionKey,
      paymentStatus: selecetedPayment!.optionKey,
    );
  }

  void setDropdowns(bool isPayment, Options object) {
    if (isPayment) {
      this.selecetedPayment = object;
    } else {
      this.selectedDelivary = object;
    }
    orderResponse = null;
    notifyListeners();
    getOrderList(
      deliveryStatus: selectedDelivary!.optionKey,
      paymentStatus: selecetedPayment!.optionKey,
    );
  }

  Future getOrderList(
      {int page = 1,
      String paymentStatus = "",
      String deliveryStatus = ""}) async {
    var caller = await MyClient.get(
        endpoint: "/purchase-history/" +
            userId.toString() +
            "?page=" +
            page.toString(),
        queryParameters: {
          "payment_status": paymentStatus,
          "delivery_status": deliveryStatus
        });

    if (caller.statusCode == 200) {
      OrderResponse temp = OrderResponse.fromJson(jsonDecode(caller.body));

      if (orderResponse == null) {
        orderResponse = temp;
      } else {
        temp.data!.forEach((object) {
          orderResponse!.data!.add(object);
        });
      }
      notifyListeners();
    }
  }

  Future getUserId() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString(AppConstant.USER_ID);
  }

  @override
  // ignore: must_call_super
  void dispose() {
    print("Order Provider Dispose");
  }
}
