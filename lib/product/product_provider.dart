// ignore_for_file: must_call_super

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/category_response.dart';
import 'package:monarch_mart/app_models/product_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';

class ProductProvider extends ChangeNotifier {
  bool isnotInitialized = true;
  ProductResponse? response;
  CategoryResponse? categoryResponse;
  int page = 1;
  String searchText = "", urlString = "", subCategoryUrl = "";
  List<bool> currentOption = [];

  init({required String url, required String subCategoryUrl}) {
    isnotInitialized = false;
    this.urlString = url;
    this.subCategoryUrl = subCategoryUrl;
    getSubCategory(subcategoryUrl: subCategoryUrl);
    getProducts(urlString: url);
  }

  void setSearchText(String searchText) {
    this.searchText = searchText;
    response = null;
    getProducts(urlString: urlString);

    notifyListeners();
  }

  void nextProductPage() {
    page++;
    getProducts(
      urlString: urlString,
      page: page.toString(),
    );
  }

  getCategoryProducts({required String categoryUrl}) async {
    String endPoint = categoryUrl.replaceAll(AppUrl.base_url, "");
    var params = {"name": searchText, "page": page};
    response = null;
    notifyListeners();
    try {
      var caller =
          await MyClient.get(endpoint: endPoint, queryParameters: params);
      if (caller.statusCode == 200) {
        ProductResponse tempResponse =
            ProductResponse.fromJson(jsonDecode(caller.body));
        if (response == null) {
          response = tempResponse;
        } else {
          tempResponse.data!.forEach((items) {
            response!.data!.add(items);
          });
        }

        notifyListeners();
      }
    } catch (e) {}
  }

  Future getProducts({required String urlString, String page = "1"}) async {
    String endPoint = urlString.replaceAll(AppUrl.base_url, "");
    var params = {"name": searchText, "page": page};

    try {
      var caller =
          await MyClient.get(endpoint: endPoint, queryParameters: params);

      if (caller.statusCode == 200) {
        // print('flash: ${caller.body}');
        try {
          ProductResponse tempResponse =
              ProductResponse.fromJson(jsonDecode(caller.body));
          // print('flash 2: $response');
          if (response == null) {
            // print('flash null:');
            response = tempResponse;
          } else {
            tempResponse.data!.forEach((items) {
              // print('flash added: ${items}');
              response!.data!.add(items);
            });
          }
        } catch (e) {
          print('flash: $e');
        }

        notifyListeners();
      }
    } catch (e) {}
  }

  setCurrentOption(int index) {
    currentOption = List.generate(categoryResponse!.data!.length, (i) {
      if (index == i) {
        return true;
      } else {
        return false;
      }
    });
    notifyListeners();
  }

  Future getSubCategory({required String subcategoryUrl}) async {
    String endPoint = subcategoryUrl.replaceAll(AppUrl.base_url, "");

    try {
      var caller = await MyClient.get(endpoint: endPoint);
      if (caller.statusCode == 200) {
        categoryResponse = CategoryResponse.fromJson(jsonDecode(caller.body));

        currentOption = List.filled(categoryResponse!.data!.length, false);
        currentOption[0] = true;
        notifyListeners();
      }
    } catch (e) {}
  }

  @override
  void dispose() {}
}
