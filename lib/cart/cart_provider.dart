import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/cart_list_respnse.dart';
import 'package:monarch_mart/app_models/cart_models.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/controllers/loader_controller.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final LoaderController loaderController = Get.find();
  bool isInitialize = false;
  String? accessToken, userId, currencySymbol;
  String choosenOwnerId = "";
  List<CartListResponse>? cartLists;
  CommonResponse? processResponse;
  var cartIds = [];
  var cartQuantities = [];
  int currentmainIndex = 0;
  late List<CartModel> cartModel = [];

  late BuildContext context;
  double totalCost = 0;

  init({required BuildContext context}) {
    isInitialize = true;
    this.context = context;
    getUserinfo().then((list) {
      accessToken = list[0];
      userId = list[1];
      getCartItemList();
    });
  }

  void selectShop(int mainIndex) {
    this.currentmainIndex = mainIndex;
    this.choosenOwnerId = cartModel[currentmainIndex].ownerId.toString();
    countTotalCost();
    notifyListeners();
  }

  void incrementQuantity(int mainIndex, int subIndex) {
    print(cartModel[mainIndex].itemsList![subIndex].quantity);
    if (cartModel[mainIndex].itemsList![subIndex].quantity! <
        cartModel[mainIndex].itemsList![subIndex].upperLimit!) {
      cartModel[mainIndex].itemsList![subIndex].quantity =
          cartModel[mainIndex].itemsList![subIndex].quantity! + 1;

      countTotalCost();
    } else {
      Toast.createToast(
          context: context,
          message: "Can not order more than " +
              cartModel[mainIndex].itemsList![subIndex].upperLimit!.toString() +
              " item(s) of this",
          duration: Duration(milliseconds: 1000));
    }
    notifyListeners();
  }

  void decrementQuantity(int mainIndex, int subIndex) {
    print(cartModel[mainIndex].itemsList![subIndex].quantity);
    if (cartModel[mainIndex].itemsList![subIndex].quantity! >
        cartModel[mainIndex].itemsList![subIndex].lowerLimit!) {
      cartModel[mainIndex].itemsList![subIndex].quantity =
          cartModel[mainIndex].itemsList![subIndex].quantity! - 1;

      countTotalCost();
    } else {
      Toast.createToast(
          context: context,
          message: "Can not order less than " +
              cartModel[mainIndex].itemsList![subIndex].lowerLimit!.toString() +
              " item(s) of this",
          duration: Duration(milliseconds: 1000));
    }
    notifyListeners();
  }

  refresh() {
    cartModel = [];
    notifyListeners();
    getCartItemList();
  }

  void deleteItem(Model data, int mainIndex, int subIndex) {
    cartModel[mainIndex].itemsList!.removeAt(subIndex);
    notifyListeners();
    deleteCartItem(cartId: data.id.toString());
  }

  Future getCartItemList() async {
    var url = Uri.parse(AppUrl.base_url + "/carts/" + userId.toString());
    var caller = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    });
    print('Cart Response: ${caller.body}');
    if (caller.statusCode == 200) {
      cartLists = (jsonDecode(caller.body) as List)
          .map((ob) => CartListResponse.fromJson(ob))
          .toList();

      if (cartLists!.isNotEmpty) {
        choosenOwnerId = cartLists![currentmainIndex].ownerId.toString();
        print(choosenOwnerId);
        cartLists!.forEach((response) {
          List<Model> modelList = [];
          response.cartItems!.forEach((element) {
            currencySymbol = element.currencySymbol;
            modelList.add(Model(
              id: element.id,
              currencySymbol: element.currencySymbol,
              lowerLimit: element.lowerLimit,
              upperLimit: element.upperLimit,
              ownerId: element.ownerId,
              price: element.price,
              productId: element.productId,
              productName: element.productName,
              productThumbnailImage: element.productThumbnailImage,
              quantity: element.quantity,
              shippingCost: element.shippingCost,
              tax: element.tax,
              userId: element.userId,
              variation: element.variation,
            ));
          });

          cartModel.add(CartModel(
              ownerId: response.ownerId,
              title: response.name,
              itemsList: modelList));
        });
      }

      if (cartLists!.isNotEmpty) {
        countTotalCost();
      }

      notifyListeners();
    }
  }

  Future deleteCartItem({required String cartId}) async {
    var caller = await MyClient.delete(endpoint: "/carts/" + cartId);
    if (caller.statusCode == 200) {
      var resp = CommonResponse.fromJson(jsonDecode(caller.body));

      if (resp.result) {
        Provider.of<AppProvider>(context, listen: false).getTotalItemsinCart();
        countTotalCost();
        Toast.createToast(
            context: context,
            message: resp.message.toString(),
            duration: Duration(
              milliseconds: 1000,
            ));
      } else {
        Toast.createToast(
            context: context,
            message: resp.message.toString(),
            duration: Duration(
              milliseconds: 1000,
            ));
      }
      notifyListeners();
    }
  }

  void processCart() {
    if (!loaderController.orderLoader.value) {
      if (cartModel[currentmainIndex].itemsList!.isNotEmpty) {
        loaderController.orderLoader.value = true;
        cartModel[currentmainIndex].itemsList!.forEach((ob) {
          cartIds.add(ob.id);
          cartQuantities.add(ob.quantity);
        });

        var cartIdsString = cartIds.join(',').toString();
        var cartQuantitiesString = cartQuantities.join(',').toString();

        postToProcessCart(
                cartIds: cartIdsString, cartQuantities: cartQuantitiesString)
            .then((value) {
          loaderController.orderLoader.value = false;
          switch (value) {
            case AppConstant.SUCCESS:
              Provider.of<AppProvider>(context, listen: false)
                  .getTotalItemsinCart();
              toast(processResponse!.message.toString());
              Navigator.pushNamed(context, AppRoute.address,
                  arguments:
                      ScreenArguments(data: {"ownerId": choosenOwnerId}));

              break;
            case AppConstant.FAILED:
              toast(processResponse!.message.toString());
              break;
            default:
              toast("Network Error!!!!");
              break;
          }
        });
      } else {
        toast("Cart is empty!!");
      }
    }
  }

  Future postToProcessCart(
      {required String cartIds, required String cartQuantities}) async {
    var postBody = {"cart_ids": cartIds, "cart_quantities": cartQuantities};

    try {
      var caller =
          await MyClient.post(endpoint: "/carts/process", bodyData: postBody);
      processResponse = CommonResponse.fromJson(jsonDecode(caller.body));

      if (processResponse!.result) {
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

  void countTotalCost() {
    totalCost = 0;
    cartModel.forEach((cartModelob) {
      cartModelob.itemsList!.forEach((ob) {
        totalCost = totalCost + ob.quantity! * ob.price!;
      });
    });
  }

  toast(String message) {
    Toast.createToast(
        context: context, message: message, duration: Duration(seconds: 1));
  }

  @override
  // ignore: must_call_super
  void dispose() {
    print("cart provider dispose");
  }
}
