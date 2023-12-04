// ignore_for_file: must_call_super

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/category_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryResponse? response;

  init(String url) {
    getCategory(url);
  }

  Future getCategory(String urlString) async {
    String endPoint = urlString.replaceAll(AppUrl.base_url, "");
    try {
      var caller = await MyClient.get(endpoint: endPoint);
      if (caller.statusCode == 200) {
        response = CategoryResponse.fromJson(jsonDecode(caller.body));
        print(response!.toJson());
        notifyListeners();
      }
    } catch (e) {}
  }

  @override
  void dispose() {}
}
