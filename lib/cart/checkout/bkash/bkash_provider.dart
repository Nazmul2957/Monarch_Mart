import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/bkash_response.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BkashProvider extends ChangeNotifier {
  String? userId, accessToken, ownerId, orderId;
  bool isInitialize = false;
  late BuildContext context;
  String? initialUrl;
  BkashResponse? bkashResponse;
  CommonResponse? commonResponse;

  init(
      {required BuildContext context,
      required String ownerId,
      required String orderId,
      required String amount,
      required String paymentType}) {
    isInitialize = true;
    this.context = context;
    this.ownerId = ownerId;
    getUserinfo().then((list) {
      this.accessToken = list[0];
      this.userId = list[1];
      getBkashInitials(
          paymentType: paymentType, orderId: orderId, amount: amount);
    });
  }

  Future<int> getBkashInitials(
      {required String paymentType,
      required String orderId,
      required String amount}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var url = Uri.parse(AppUrl.base_url +
          "/bkash/begin?payment_type=cart_payment&combined_order_id=$orderId");
      print(url);
      var caller = await http.get(
        url,
        headers: {
          "Authorization": "Bearer " +
              (preferences.getString(AppConstant.ACCESS_TOKEN) ?? ""),
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      bkashResponse = BkashResponse.fromJson(jsonDecode(caller.body));
      if (bkashResponse!.result!) {
        initialUrl = bkashResponse!.url;
        notifyListeners();
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  // Future<bool> bkashPaymentProcess(
  //     {required paymentType,
  //     required String amount,
  //     required String orderId,
  //     required String paymentDetails}) async {
  //   var postBody = {
  //     "user_id": userId,
  //     "payment_type": paymentType,
  //     "order_id": orderId,
  //     "amount": amount,
  //     "payment_details": paymentDetails
  //   };
  //
  //   try {
  //     var caller = await MyClient.post(
  //       endpoint: "/bkash/process",
  //       bodyData: postBody,
  //     );
  //
  //     commonResponse = CommonResponse.fromJson(jsonDecode(caller.body));
  //     return commonResponse!.result;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future getUserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));
    return holder;
  }
}
