// ignore_for_file: must_call_super

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monarch_mart/app_models/banner_response.dart';
import 'package:monarch_mart/app_models/category_response.dart';
import 'package:monarch_mart/app_models/common_banner.dart';
import 'package:monarch_mart/app_models/featured_product_response.dart';
import 'package:monarch_mart/app_models/product_object_holder.dart';
import 'package:monarch_mart/app_models/product_response.dart';
import 'package:monarch_mart/app_models/slider_response.dart';
import 'package:monarch_mart/app_models/top_category_option_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';

class HomeProvider extends ChangeNotifier {
  SliderResponse? sliderResponse;
  List<String> carouselImageList = [];

  TopCategroyOptionResponse? categroyOption;
  FeaturedProductResponse? featuredProductResponse;
  bool isnotInitialized = true;

  List<ProductObjectHolder> productObjectList = [];
  CommonBanner? firstBannerblock, secondBannerBlock, thirdbannner;
  BannerResponse? bannerResponse;

  init() {
    isnotInitialized = false;

    getSliderImages();
    getTopCategoryOption();
    getFeaturedProduct();
    getBanner();
    getFirstBannerBlock();
    getSecondBannerBlock();
    getCats();
  }

  refresh() {
    categroyOption = null;
    featuredProductResponse = null;
    featuredProductResponse = null;
    productObjectList = [];
    notifyListeners();
    getBanner();
    getSliderImages();
    getTopCategoryOption();
    getFeaturedProduct();
    getCats();
    getFirstBannerBlock();
    getSecondBannerBlock();
  }

  void getCats() async {
    await getProductCategory();
    await getProductCategory2();
  }

  Future getFirstBannerBlock() async {
    try {
      var caller = await MyClient.get(endpoint: "/flash-deal-banners");
      if (caller.statusCode == 200) {
        firstBannerblock = CommonBanner.fromJson(jsonDecode(caller.body));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getSecondBannerBlock() async {
    try {
      var caller = await MyClient.get(endpoint: "/flash-deal-sliders");
      if (caller.statusCode == 200) {
        secondBannerBlock = CommonBanner.fromJson(jsonDecode(caller.body));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getSliderImages() async {
    carouselImageList = [];
    try {
      var response = await MyClient.get(endpoint: "/sliders");
      if (response.statusCode == 200) {
        sliderResponse = SliderResponse.fromJson(jsonDecode(response.body));
        sliderResponse!.data!.forEach((image) {
          carouselImageList.add(image.photo!);
        });
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getTopCategoryOption() async {
    carouselImageList = [];
    try {
      var response = await MyClient.get(endpoint: "/categories/featured");

      if (response.statusCode == 200) {
        categroyOption =
            TopCategroyOptionResponse.fromJson(jsonDecode(response.body));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getFeaturedProduct() async {
    carouselImageList = [];
    try {
      var response = await MyClient.get(endpoint: "/products/featured");

      if (response.statusCode == 200) {
        featuredProductResponse =
            FeaturedProductResponse.fromJson(jsonDecode(response.body));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getProductCategory() async {
    try {
      var response =
          await MyClient.get(endpoint: "/category-wise-product-cats");
      print("/category-wise-product-cats");
      if (response.statusCode == 200) {
        var value = CategoryResponse.fromJson(jsonDecode(response.body));

        value.data!.forEach((data) async {
          await getCategoryProducts(
              id: data.id.toString(), title: data.name.toString());
        });
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getProductCategory2() async {
    try {
      var response =
          await MyClient.get(endpoint: "/category-wise-product-cats2");
      print("/category-wise-product-cats2");
      if (response.statusCode == 200) {
        var value = CategoryResponse.fromJson(jsonDecode(response.body));

        value.data!.forEach((data) async {
          await getCategoryProducts(
              id: data.id.toString(), title: data.name.toString());
        });
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCategoryProducts(
      {required String id, required String title}) async {
    try {
      String endPoint = "/products/category/" + id;
      print("/products/category/" + id);
      var caller = await MyClient.get(endpoint: endPoint);
      if (caller.statusCode == 200) {
        var response = ProductResponse.fromJson(jsonDecode(caller.body));

        productObjectList.add(ProductObjectHolder(
            title: title, response: response, viewMoreProductLink: endPoint));

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getBanner() async {
    try {
      var caller = await MyClient.get(endpoint: "/flash-deal-featured");
      if (caller.statusCode == 200) {
        bannerResponse = BannerResponse.fromJson(jsonDecode(caller.body));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {}
}
