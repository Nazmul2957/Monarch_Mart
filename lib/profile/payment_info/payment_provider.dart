import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/wallet_balance_response.dart';
import 'package:monarch_mart/app_models/wallet_recharge_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider extends ChangeNotifier {
  late SharedPreferences preferences;
  bool isInitialized = false;
  String? accessToken, userId;
  WalletBalanceResponse? balanceResponse;
  WalletRechargeResponse? rechargeResponse;
  int page = 1;
  init() {
    isInitialized = true;
    getUserInfo().then((list) {
      this.accessToken = list[0];
      this.userId = list[1];
      getBalance();
      getRechargeList();
    });
  }

  void nextPage() {
    page++;
    getRechargeList(page: page);
  }

  Future getBalance() async {
    var caller =
        await MyClient.get(endpoint: "/wallet/balance/" + userId.toString());
    if (caller.statusCode == 200) {
      balanceResponse = WalletBalanceResponse.fromJson(jsonDecode(caller.body));
      notifyListeners();
    }
  }

  Future getRechargeList({int page = 1}) async {
    var caller = await MyClient.get(
      endpoint:
          "/wallet/history/" + userId.toString() + "?page=" + page.toString(),
    );
    if (caller.statusCode == 200) {
      WalletRechargeResponse temp =
          WalletRechargeResponse.fromJson(jsonDecode(caller.body));
      if (rechargeResponse == null) {
        rechargeResponse = temp;
      } else {
        temp.data!.forEach((data) {
          rechargeResponse!.data!.add(data);
        });
      }
      notifyListeners();
    }
  }

  Future<List> getUserInfo() async {
    preferences = await SharedPreferences.getInstance();
    List<String?> holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));

    return holder;
  }

  @override
  // ignore: must_call_super
  void dispose() {
    print("Wallet Provider disposed");
  }
}
