import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_components/app_constant.dart';
import '../app_models/common_response.dart';
import '../app_models/featured_product_response.dart';
import '../app_models/product_details_response.dart';

Future<FeaturedProductResponse> getFeaturedProduct() async {
  FeaturedProductResponse mCourse = FeaturedProductResponse();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String accessToken = pref.getString(AppConstant.ACCESS_TOKEN) ?? "";
  print('accessToken: $accessToken');
  var url = '${AppUrl.base_url}/products/featured';
  try {
    var response = await http.get(
      Uri.parse(url),
      headers: {
        // "Authorization": "Bearer " + accessToken,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    print('Response apiExamStart status: ${response.statusCode}');
    print('Response apiExamStart body: ${response.body}');
    mCourse = FeaturedProductResponse.fromJson(jsonDecode(response.body));

    return mCourse;
  } catch (e) {
    print("apiExamStart Error : ${e.toString()}");
    return FeaturedProductResponse(success: false);
  }
}

Future<ProductDetailsResponse> productDetails() async {
  ProductDetailsResponse mCourse = ProductDetailsResponse();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String accessToken = pref.getString(AppConstant.ACCESS_TOKEN) ?? "";
  print('accessToken: $accessToken');
  var url = '${AppUrl.base_url}/products/30986';
  try {
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer " + accessToken,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    print('Response apiExamStart status: ${response.statusCode}');
    print('Response apiExamStart body: ${response.body}');
    mCourse = ProductDetailsResponse.fromJson(jsonDecode(response.body));

    return mCourse;
  } catch (e) {
    print("apiExamStart Error : ${e.toString()}");
    return ProductDetailsResponse(success: false);
  }
}

Future<CommonResponse> cartAdd(var body) async {
  CommonResponse mCourse = CommonResponse(result: false);
  SharedPreferences pref = await SharedPreferences.getInstance();
  String accessToken = pref.getString(AppConstant.ACCESS_TOKEN) ?? "";
  print('accessToken: $accessToken');
  var url = '${AppUrl.base_url}/carts/add';
  try {
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        "Authorization": "Bearer " + accessToken,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    print('Response cartAdd status: ${response.statusCode}');
    print('Response cartAdd body: ${response.body}');
    mCourse = CommonResponse.fromJson(jsonDecode(response.body));

    return mCourse;
  } catch (e) {
    print("cartAdd Error : ${e.toString()}");
    return CommonResponse(result: false);
  }
}
