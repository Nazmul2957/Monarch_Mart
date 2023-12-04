import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/commerz_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSlCommerzProvider extends ChangeNotifier {
  String? userId, accessToken, ownerId, orderId;
  bool isInitialize = false;
  late BuildContext context;
  String initialUrl = "";
  String? mainUrl;

  init(
      {required BuildContext context,
      required String ownerId,
      required String orderId,
      required String amount,
      required String paymentType}) {
    isInitialize = true;
    this.context = context;
    this.ownerId = ownerId;
    this.orderId = orderId;
    getUserinfo().then((list) {
      this.accessToken = list[0];
      this.userId = list[1];
      getWebUrl(amount: amount, paymentType: paymentType);
      notifyListeners();
    });
  }

  Future getWebUrl(
      {required String amount, required String paymentType}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/sslcommerz/begin?payment_type=" + paymentType,
          queryParameters: {
            "combined_order_id": orderId.toString(),
            "amount": amount.toString(),
            "user_id": userId.toString()
          });
      if (caller.statusCode == 200) {
        var result = CommerzResponse.fromJson(jsonDecode(caller.body));
        mainUrl = result.url.toString();
        notifyListeners();
      }
    } catch (e) {
      print(e);
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
