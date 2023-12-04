import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_models/review_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductReviewProvider extends ChangeNotifier {
  String? productId, accessToken, userId;
  bool isInitialize = false;
  ReviewResponse? reviewResponse;
  late BuildContext context;
  double myrating = 5;

  int page = 1;
  init({required String productId, required BuildContext context}) {
    this.productId = productId;
    isInitialize = true;
    this.context = context;

    getUserinfo().then((list) {
      accessToken = list[0];
      userId = list[1];
      getAllReviews(page: page);
    });
  }

  void setRating(double rating) {
    this.myrating = rating;
    notifyListeners();
  }

  void nextPage() {
    page++;
    getAllReviews(page: page);
  }

  void refresh() {
    reviewResponse = null;
    page = 1;
    getAllReviews(page: page);
  }

  Future getAllReviews({required int page}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/reviews/product/" +
              productId.toString() +
              "?page=" +
              page.toString());

      reviewResponse = ReviewResponse.fromJson(jsonDecode(caller.body));
      print(reviewResponse);
      notifyListeners();
    } catch (e) {}
  }

  Future submitReview({required double rating, required String comment}) async {
    var postBody = {
      "product_id": productId,
      "user_id": userId,
      "rating": rating,
      "comment": comment
    };

    try {
      var caller = await MyClient.post(
        endpoint: "/reviews/submit",
        bodyData: postBody,
      );
      var response = CommonResponse.fromJson(jsonDecode(caller.body));

      if (response.result) {
        print(response.result);
        print("review success");
        Toast.createToast(
            context: context,
            message: response.message!,
            duration: Duration(milliseconds: 1500));
      } else {
        print(response.message);
        print("respons review");
        Toast.createToast(
            context: context,
            message: response.message!,
            duration: Duration(milliseconds: 1500));
      }

      notifyListeners();
    } catch (e) {}
  }

  Future getUserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));
    return holder;
  }
}
