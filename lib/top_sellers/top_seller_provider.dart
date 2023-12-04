// ignore_for_file: must_call_super

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_models/best_seller_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';

class TopSellerProvider extends ChangeNotifier {
  BestSellerResponse? response;

  void refresh() {
    response = null;
    notifyListeners();
    getTopSellingProducts();
  }

  Future getTopSellingProducts() async {
    try {
      var caller = await MyClient.get(endpoint: "/shops/best-seller");
      if (caller.statusCode == 200) {
        print(caller.body);
        response = BestSellerResponse.fromJson(jsonDecode(caller.body));

        notifyListeners();
      }
    } catch (e) {}
  }

  @override
  void dispose() {}
}
