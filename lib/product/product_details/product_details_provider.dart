// ignore_for_file: must_call_super, unused_local_variable

import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as client;
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_models/product_details_response.dart';
import 'package:monarch_mart/app_models/variant_response.dart';
import 'package:monarch_mart/app_models/variation.dart';
import 'package:monarch_mart/app_models/wishlist_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/controllers/loader_controller.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final LoaderController loaderController = Get.find();
  ProductDetailsResponse? response;
  VariantResponse? responseVariant;

  CommonResponse? addingResponse;
  bool isAdded = false, isInWishList = false, hasDiscount = false;
  bool isInitialize = false;
  late CarouselController carouselController = new CarouselController();
  List<String?> carouselImageList = [];
  List<String>? colorsList = [];
  Variation? currentVariation;
  List<Variation>? variationList = [];
  int currentWidgetIndex = 0;
  String currentSku = "...";
  bool inStock = false;
  String? userId, accessToken, productDescription;

  late BuildContext context;
  String selectedVariant = "", selectedColor = "";
  List<Map<String, String>> variantMap = [];
  String appBarPrice = "....",
      mainPriceString = "....",
      currencySymbol = "",
      productId = "0",
      variant = "",
      strokedPrice = "",
      brand = "...",
      brandLink = "";

  double calCulablePrice = 0;
  int currentSlider = 0, quantity = 1, stock = 0;

  // NetworkProgress progress = new NetworkProgress();

  void initializer({required String productId, required BuildContext context}) {
    this.context = context;
    this.productId = productId;
    isInitialize = true;
    getUserinfo().then((list) {
      this.accessToken = list[0];
      this.userId = list[1];
      print("Access Token:" + accessToken.toString());
      if (accessToken != null) {
        getUserWishList(productId: productId);
      }
      getDetails(id: productId);
      // getSimilarProduct(id: productId);
    });
  }

  void incrementQuantity() {
    if (quantity < stock) {
      quantity++;
    }
    notifyListeners();
  }

  void decrementQuantity() {
    if (quantity > 0) {
      quantity--;
    }
    notifyListeners();
  }

  void changeWishList({required String productId}) {
    isInWishList = !isInWishList;
    if (isInWishList) {
      addProductToWishList(productId: productId);
    } else {
      removeProductFromWishList(productId: productId);
    }
    notifyListeners();
  }

  void currentWidget(int index) {
    this.currentWidgetIndex = index;
    notifyListeners();
  }

  void changeVariation(Variation variation, int index, int selectedIndex) {
    variation.selectedOption = selectedIndex;
    variationList![index] = variation;
    variantMap[index][variationList![index].title.toString()] =
        variation.sizeOptions![selectedIndex];
    print(variantMap);
    setVariants();
    reset();
    notifyListeners();
  }

  void reset() {
    appBarPrice = "Loading..";
    mainPriceString = "Loading..";
    calCulablePrice = 0;
  }

  setCurrentSlider(int sliderPos) {
    this.currentSlider = sliderPos;
    carouselController.jumpToPage(currentSlider);
    notifyListeners();
  }

  // Future getSimilarProduct({String id = "0"}) async {
  //   try {
  //     var caller = await MyClient.get(endpoint: "/products/related/" + id);

  //     if (caller.statusCode == 200) {
  //       responseSimilarProduct =
  //           CommonProductResponse.fromJson(jsonDecode(caller.body));
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future getUserWishList({required String productId}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/wishlists-check-product?product_id=" + productId,
          queryParameters: {
            "user_id": userId.toString(),
          });
      if (caller.statusCode == 200) {
        var responseWishlist =
            WishlistResponse.fromJson(jsonDecode(caller.body));
        isInWishList = responseWishlist.isInWishlist;

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future addProductToWishList({required String productId}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/wishlists-add-product?product_id=" + productId,
          queryParameters: {
            "user_id": userId.toString(),
          });

      if (caller.statusCode == 200) {
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future removeProductFromWishList({required String productId}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/wishlists-remove-product?product_id=" + productId,
          queryParameters: {"user_id": userId.toString()});
      if (caller.statusCode == 200) {
        var responseWishlist =
            WishlistResponse.fromJson(jsonDecode(caller.body));

        isInWishList = responseWishlist.isInWishlist;

        notifyListeners();
      } else {
        print(jsonDecode(caller.body));
      }
    } catch (e) {
      print(e);
    }
  }

  Future getVariants(
      {String id = "0",
      String choosenColor = "",
      String choosenSize = ""}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String accessToken =
          preferences.getString(AppConstant.ACCESS_TOKEN) ?? "";
      var url = AppUrl.base_url + "/products/variant/price";

      var body = jsonEncode({
        "id": id,
        "color": choosenColor,
        "variants": choosenSize,
      });
      print(body);
      print(url);
      var caller = await client.post(Uri.parse(url),
          headers: {
            // "Authorization": "Bearer " + accessToken,
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: body);

      if (caller.statusCode == 200) {
        responseVariant = VariantResponse.fromJson(jsonDecode(caller.body));

        print("variant: $responseVariant");
        variant = responseVariant!.variant!;
        setVariantImage(variant);
        reassign();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getDetails({String id = "0"}) async {
    try {
      var caller = await MyClient.get(endpoint: "/products/" + id);

      if (caller.statusCode == 200) {
        response = ProductDetailsResponse.fromJson(jsonDecode(caller.body));

        assign();
      }
    } catch (e) {
      print(e);
    }
  }

  void setVariantImage(String variant) {
    for (var i = 0; i < response!.data![0].photos!.length; i++) {
      if (variant == response!.data![0].photos![i].variant) {
        setCurrentSlider(i);
      }
    }
    response!.data![0].photos!.forEach((photo) {});
  }

  void reassign() {
    appBarPrice = responseVariant!.priceString!;
    mainPriceString = currencySymbol + " " + responseVariant!.price.toString();
    stock = responseVariant!.stock!;
    calCulablePrice = responseVariant!.price!.toDouble();
    quantity = stock == 0 ? 0 : 1;
    currentSku = responseVariant!.sku.toString();
    inStock = responseVariant!.stock! > 0;
    notifyListeners();
  }

  void assign() {
    appBarPrice = response!.data![0].priceHighLow.toString();
    productId = response!.data![0].id.toString();
    mainPriceString = response!.data![0].mainPrice.toString();
    brand = response!.data![0].brand ?? "...";
    brandLink = response!.data![0].onClickBrand ?? "";
    calCulablePrice =
        double.parse(response!.data![0].calculablePrice.toString());
    stock = response!.data![0].currentStock!;
    quantity = stock == 0 ? 0 : 1;
    productDescription = response!.data![0].description;
    currencySymbol = response!.data![0].currencySymbol.toString();
    hasDiscount = response!.data![0].hasDiscount!;
    strokedPrice = response!.data![0].strokedPrice!;
    currentSku = response!.data![0].baseSku.toString();
    inStock = response!.data![0].currentStock! > 0;
    if (carouselImageList.isEmpty) {
      response!.data![0].photos!.forEach((image) {
        carouselImageList.add(image.path);
      });
    }

    if (response!.data![0].choiceOptions!.isNotEmpty) {
      response!.data![0].choiceOptions!.forEach((element) {
        if (element.options!.isNotEmpty) {
          variantMap.add({element.title!: element.options![0]});
        }

        variationList!.add(Variation(
            title: element.title,
            sizeOptions: element.options,
            selectedOption: 0));
        print(variationList);
      });
    }

    print("initial variants: " + variantMap.toString());

    if (variantMap.isNotEmpty) {
      setVariants();
    }
    notifyListeners();
  }

  void setVariants() {
    selectedColor = "";
    selectedVariant = "";
    for (var i = 0; i < variationList!.length; i++) {
      if (variationList![i].title != "Color") {
        selectedVariant = selectedVariant +
            (selectedVariant.isNotEmpty ? "-" : "") +
            variantMap[i][variationList![i].title].toString();
      } else {
        if (variationList![i].sizeOptions!.isNotEmpty) {
          selectedColor = variantMap[i][variationList![i].title]
              .toString()
              .replaceAll("#", "");
        }
      }
    }

    print("This is selected Color: " + selectedColor);
    print("This is Selected Variants:" + selectedVariant);
    getVariants(
        id: productId,
        choosenSize: selectedVariant,
        choosenColor: selectedColor);
  }

  void addProductToCart({required String productId, bool isBuyNow = false}) {
    // progress.showProgress(context);
    if (!loaderController.cartLoader.value) {
      loaderController.cartLoader.value = true;
      loaderController.isBuyNow.value = isBuyNow;
      postProductToServerCart(productId: productId).then((value) {
        // progress.closeDialog();
        loaderController.cartLoader.value = false;
        if (value == AppConstant.SUCCESS) {
          Provider.of<AppProvider>(context, listen: false)
              .getTotalItemsinCart();

          if (isBuyNow) {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoute.cart, (route) => false);
          } else {
            Toast.createToast(
                context: context,
                message: addingResponse?.message.toString() ?? "",
                duration: Duration(seconds: 1));
          }
        } else {
          Toast.createToast(
              context: context,
              message: addingResponse?.message.toString() ?? "",
              duration: Duration(seconds: 1));
        }
      });
    }
  }

  Future<int> postProductToServerCart({required String productId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (variant == "") {
      await getDetails(id: productId);
    }
    var postBody = {
      "id": productId,
      "variant": variant.toString(),
      "user_id": preferences.getString(AppConstant.USER_ID),
      "quantity": quantity.toString(),
      "cost_matrix": AppConstant.purchase_code
    };
    print(postBody);
    try {
      var caller =
          await MyClient.post(endpoint: "/carts/add", bodyData: postBody);
      print(caller.body);
      addingResponse = CommonResponse.fromJson(jsonDecode(caller.body));

      if (addingResponse!.result) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future getUserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));
    return holder;
  }

  @override
  void dispose() {}
}
