// ignore_for_file: must_call_super

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_models/brand_response.dart';
import 'package:monarch_mart/app_models/category_response.dart';
import 'package:monarch_mart/app_models/filter_brand_response.dart';
import 'package:monarch_mart/app_models/filter_product_response.dart';
import 'package:monarch_mart/app_models/filter_seller_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';

class FilterProvider extends ChangeNotifier {
  String searchText = "";
  int fltrPrdctPage = 1, fltrBrndPage = 1, fltrShpsPage = 1;
  int? categoryIndex;
  String currentCategory = "", sortingCategory = "";
  String? selectedCategories = "",
      selectedBrands = "",
      minimumPrice = "",
      maximumPrice = "";
  bool isEnabled = false;
  int productAvailable = 100, brandsAvailable = 100, sellersAvailable = 100;
  CategoryResponse? categoryresponse;
  BrandResponse? brandResponse;

  FilterProductResponse? filterproductResponse;
  FilterBrandResponse? filterbrandResponse;
  FilterSellerResponse? filtersellerResponse;

  init({required String currentCategory, required String sorting}) {
    this.currentCategory = currentCategory;
    sortingCategory = sorting;
    if (currentCategory == AppString.Brands) {
      categoryIndex = 0;

      getFilterdBrands(page: fltrBrndPage, name: searchText);
    } else if (currentCategory == AppString.Product) {
      categoryIndex = 1;
      isEnabled = true;
      getFilterdProducts(
          name: searchText, page: fltrPrdctPage, sortkey: sortingCategory);
    } else {
      categoryIndex = 2;

      getFilteredShops(name: searchText, page: fltrShpsPage);
    }

    getCategory();
    getBrands();
  }

  Future getCategory() async {
    try {
      var caller = await MyClient.get(endpoint: "/filter/categories");

      if (caller.statusCode == 200) {
        categoryresponse = CategoryResponse.fromJson(jsonDecode(caller.body));
      }
    } catch (e) {
      print(e);
    }
  }

  Future getBrands() async {
    try {
      var caller = await MyClient.get(endpoint: "/filter/brands");
      if (caller.statusCode == 200) {
        brandResponse = BrandResponse.fromJson(jsonDecode(caller.body));
      }
    } catch (e) {
      print(e);
    }
  }

  void nextBrandsPage() {
    fltrBrndPage++;
    getFilterdBrands(
      name: searchText,
      page: fltrBrndPage,
    );
  }

  void nextProductPage() {
    fltrPrdctPage++;
    getFilterdProducts(
      name: searchText,
      sortkey: sortingCategory,
      page: fltrPrdctPage,
      brands: selectedBrands,
      categories: selectedCategories,
      max: maximumPrice,
      min: minimumPrice,
    );
  }

  void nextSellerPage() {
    fltrShpsPage++;
    getFilteredShops(
      name: searchText,
      page: fltrShpsPage,
    );
  }

  void setFilterCategory(String minPrice, String maxPrice, String slctdCategory,
      String slctdBrands) {
    this.maximumPrice = maxPrice;
    this.minimumPrice = minPrice;
    this.selectedCategories = slctdCategory;
    this.selectedBrands = slctdBrands;
    resetProduct();
    notifyListeners();
    getFilterdProducts(
      name: searchText,
      sortkey: sortingCategory,
      page: fltrPrdctPage,
      brands: selectedBrands,
      categories: selectedCategories,
      max: maximumPrice,
      min: minimumPrice,
    );
  }

  void setSortingCategory(String category) {
    this.sortingCategory = category;
    resetProduct();
    notifyListeners();
    getFilterdProducts(
      name: searchText,
      sortkey: sortingCategory,
      page: fltrPrdctPage,
      brands: selectedBrands,
      categories: selectedCategories,
      max: maximumPrice,
      min: minimumPrice,
    );
  }

  void setCurrentCategory(String s) {
    currentCategory = s;
    if (s.contains("Product")) {
      categoryIndex = 1;
      resetProduct();
      getFilterdProducts(
        name: searchText,
        sortkey: sortingCategory,
        page: fltrPrdctPage,
        brands: selectedBrands,
        categories: selectedCategories,
        max: maximumPrice,
        min: minimumPrice,
      );
      isEnabled = true;
    } else if (s.contains("Brands")) {
      categoryIndex = 0;
      resetBrands();
      getFilterdBrands(page: fltrBrndPage, name: searchText);
      isEnabled = false;
    } else {
      categoryIndex = 2;
      resetSellers();
      getFilteredShops(name: searchText, page: fltrShpsPage);
      isEnabled = false;
    }
    notifyListeners();
  }

  Future<void> onRefresh(int currentOption) async {
    switch (currentOption) {
      case 0:
        resetBrands();
        getFilterdBrands(page: fltrBrndPage, name: searchText);
        break;
      case 1:
        resetProduct();
        getFilterdProducts(
          name: searchText,
          sortkey: sortingCategory,
          page: fltrPrdctPage,
          brands: selectedBrands,
          categories: selectedCategories,
          max: maximumPrice,
          min: minimumPrice,
        );
        break;
      default:
        resetSellers();
        getFilteredShops(name: searchText, page: fltrShpsPage);
        break;
    }
    notifyListeners();
  }

  void setSearchText(String text, int currentOption) {
    this.searchText = text;
    if (searchText.isNotEmpty) {
      switch (currentOption) {
        case 0:
          resetBrands();
          getFilterdBrands(page: fltrBrndPage, name: searchText);
          break;
        case 1:
          resetProduct();
          getFilterdProducts(
            name: searchText,
            sortkey: sortingCategory,
            page: fltrPrdctPage,
            brands: selectedBrands,
            categories: selectedCategories,
            max: maximumPrice,
            min: minimumPrice,
          );
          break;
        default:
          resetSellers();
          getFilteredShops(name: searchText, page: fltrShpsPage);
          break;
      }
    } else {}

    notifyListeners();
  }

  void resetProduct() {
    filterproductResponse = null;
    fltrPrdctPage = 1;
  }

  void resetSellers() {
    filtersellerResponse = null;
    fltrShpsPage = 1;
  }

  void resetBrands() {
    filterbrandResponse = null;
    fltrBrndPage = 1;
  }

  Future getFilterdProducts(
      {name = "",
      sortkey = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {
    try {
      print('categories: $categories');
      Map<String, dynamic> queryParameters = {
        "page": page.toString(),
        "name": name,
        "sort_key": sortkey,
        "brands": brands,
        "categories": categories,
        "min": min,
        "max": max
      };
      print('queryParameters: $queryParameters');
      var caller = await MyClient.get(
          endpoint: "/products/search", queryParameters: queryParameters);
      if (caller.statusCode == 200) {
        FilterProductResponse tempResponse =
            FilterProductResponse.fromJson(jsonDecode(caller.body));
        print('tempResponse: ${caller.body}');
        if (filterproductResponse == null) {
          filterproductResponse = tempResponse;
        } else {
          tempResponse.data!.forEach((items) {
            filterproductResponse!.data!.add(items);
          });
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getFilterdBrands({name = "", page = 1}) async {
    try {
      var caller = await MyClient.post(
          endpoint: "/brands?page=$page", bodyData: {"name": name});

      if (caller.statusCode == 200) {
        FilterBrandResponse tempResponse =
            FilterBrandResponse.fromJson(jsonDecode(caller.body));
        if (filterbrandResponse == null) {
          filterbrandResponse = tempResponse;
        } else {
          tempResponse.data!.forEach((items) {
            filterbrandResponse!.data!.add(items);
          });
        }

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getFilteredShops({name = "", page = 1}) async {
    try {
      var caller;
      if (name == "") {
        caller = await MyClient.get(endpoint: "/shops?page=$page");
      } else {
        caller = await MyClient.post(
            endpoint: "/shops/search", bodyData: {"name": name});
      }

      print(jsonDecode(caller.body));
      if (caller.statusCode == 200) {
        FilterSellerResponse tempResponse =
            FilterSellerResponse.fromJson(jsonDecode(caller.body));
        if (filtersellerResponse == null) {
          filtersellerResponse = tempResponse;
        } else {
          tempResponse.data!.forEach((items) {
            filtersellerResponse!.data!.add(items);
          });
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {}
}
