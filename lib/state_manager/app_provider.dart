import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/cart_list_respnse.dart';
import 'package:monarch_mart/app_models/category_response.dart';
import 'package:monarch_mart/app_models/drawer_item_model.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_components/app_route.dart';

class AppProvider extends ChangeNotifier {
  int currentIndex = 0;
  late BuildContext context;
  CategoryResponse? categoryResponse;
  List<DrawerItemModel>? item;

  String? userName, userEmail, accessToken, userAvter, password, userId;
  int totalCartProducts = 0;

  AppProvider() {
    getSavedData();
    getDrawerCategory();
  }

  void bottomNavigation(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void getSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userName = preferences.getString(AppConstant.USER_NAME);
    userEmail = preferences.getString(AppConstant.USER_EMAIL);
    accessToken = preferences.getString(AppConstant.ACCESS_TOKEN);
    userAvter = preferences.getString(AppConstant.USER_AVETER);
    password = preferences.getString(AppConstant.USER_PASSWORD);
    userId = preferences.getString(AppConstant.USER_ID);
    getTotalItemsinCart();
    notifyListeners();
  }

  void updateName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppConstant.USER_NAME, name);
    userName = name;
    notifyListeners();
  }

  void updatePhoto(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppConstant.USER_AVETER, url);
    userAvter = url;
    notifyListeners();
  }

  void deleteSaveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    accessToken = null;
    userName = null;
    userEmail = null;
    userAvter = null;
    password = null;
    userId = null;
    totalCartProducts = 0;
    preferences.remove(AppConstant.USER_NAME);
    preferences.remove(AppConstant.USER_EMAIL);
    preferences.remove(AppConstant.ACCESS_TOKEN);
    preferences.remove(AppConstant.USER_AVETER);
    preferences.remove(AppConstant.USER_PASSWORD);
    preferences.remove(AppConstant.USER_ID);
    getTotalItemsinCart();
    notifyListeners();
    // Navigator.pushNamedAndRemoveUntil(
    //     Get.context!, AppRoute.home, (route) => false);
  }

  void setCredentials(
      {required String accessToken,
      required String userName,
      required String userEmail,
      required String userAvater,
      required String password,
      required String userId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    this.userId = userId;
    this.userName = userName;
    this.accessToken = accessToken;
    this.userEmail = userEmail;
    this.userAvter = userAvater;
    this.password = password;
    preferences.setString(AppConstant.USER_NAME, userName);
    preferences.setString(AppConstant.USER_EMAIL, userEmail);
    preferences.setString(AppConstant.ACCESS_TOKEN, accessToken);
    preferences.setString(AppConstant.USER_AVETER, userAvater);
    preferences.setString(AppConstant.USER_PASSWORD, password);
    preferences.setString(AppConstant.USER_ID, userId);
    getTotalItemsinCart();
    notifyListeners();
  }

  Future<int> getTotalItemsinCart() async {
    List<CartListResponse>? cartLists;
    totalCartProducts = 0;
    var caller = await MyClient.post(
        endpoint: "/carts/" + userId.toString(), bodyData: {});
    if (caller.statusCode == 200) {
      cartLists = (jsonDecode(caller.body) as List)
          .map((ob) => CartListResponse.fromJson(ob))
          .toList();

      if (cartLists.isNotEmpty) {
        cartLists.forEach((response) {
          totalCartProducts = totalCartProducts + response.cartItems!.length;
        });
      } else {
        totalCartProducts = 0;
      }
    } else {
      totalCartProducts = 0;
    }
    notifyListeners();
    return totalCartProducts;
  }

  Future getDrawerCategory() async {
    try {
      var caller = await MyClient.get(endpoint: "/categories");
      if (caller.statusCode == 200) {
        item = [];
        categoryResponse = CategoryResponse.fromJson(jsonDecode(caller.body));
        categoryResponse!.data!.forEach((data) {
          getDrawerSubCategory(
              data: data, subCategoryUrl: data.links!.subCategories);
        });
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getDrawerSubCategory({String? subCategoryUrl, Data? data}) async {
    try {
      String endpoint = subCategoryUrl!.replaceAll(AppUrl.base_url, "");

      var caller = await MyClient.get(endpoint: endpoint);
      if (caller.statusCode == 200) {
        var res = CategoryResponse.fromJson(jsonDecode(caller.body));
        item?.add(DrawerItemModel(
            data: data!, isExpanded: false, subCategoryResponse: res));
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  changeExpandedState(int index) {
    item![index].isExpanded = !item![index].isExpanded;
    notifyListeners();
  }
}
