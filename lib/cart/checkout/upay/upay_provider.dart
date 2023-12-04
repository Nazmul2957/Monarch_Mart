import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_models/nagad_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpayProvider extends ChangeNotifier {
  String? userId, accessToken, ownerId, orderId;
  bool isInitialize = false;
  late BuildContext context;
  NagadResponse? nagadResponse;
  CommonResponse? commonResponse;
  String? initialUrl;
  late SharedPreferences preferences;

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
      getNagadInitials(
          paymentType: paymentType, orderId: orderId, amount: amount);
    });
  }

  Future<int> getNagadInitials(
      {required String paymentType,
        required String orderId,
        required String amount}) async {
    preferences = await SharedPreferences.getInstance();
    try {
      var url = Uri.parse(AppUrl.base_url +
          "/upay/begin?grand_total=$amount&payment_type=cart_payment&combined_order_id=$orderId");

      // var url = Uri.parse(AppUrl.base_url +
      //     "/upay/begin?grand_total=$amount&payment_type=single_order_payment&combined_order_id=$orderId");
      print(url);
      var caller = await http.get(
        url,
        // body: {'grand_total':'$amount'},
        headers: {
          // 'Authorization:': 'UPAY '.$auth,
          "Authorization": "Bearer " +
              (preferences.getString(AppConstant.ACCESS_TOKEN) ?? ""),
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      print('Access Token :${preferences.getString(AppConstant.ACCESS_TOKEN)}');
      print('Upay response Body :${caller.body}');
      nagadResponse = NagadResponse.fromJson(jsonDecode(caller.body));

      if (nagadResponse!.result!) {
        initialUrl = nagadResponse!.url;
        notifyListeners();
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  // Future<bool> nagadPaymentProcess(
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
  //       endpoint: "/upay/process",
  //       bodyData: postBody,
  //     );
  //     print("proces: $postBody");
  //     print('body: ${caller.body}');
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