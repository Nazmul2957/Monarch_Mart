import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/checkout_model.dart';
import 'package:monarch_mart/app_models/checkout_summary_response.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_models/order_create_response.dart';
import 'package:monarch_mart/app_models/payment_method_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutProvider extends ChangeNotifier {
  late BuildContext context;
  bool isNotInitialize = true;
  PaymentMethodResponse? paymentMethodResponse;
  String? selectedPaymentMethod = "", selectedPaymentMethodKey = "";
  List<CheckoutModel> checkoutModel = [];
  List<PaymentMethodResponse>? paymentOptions = [];
  String? userId, accessToken, ownerId;
  CheckoutSummaryResponse? checkoutSummaryResponse;
  OrderCreateResponse? createResponse;

  init({required BuildContext context, required String ownerId}) {
    isNotInitialize = false;
    this.context = context;
    this.ownerId = ownerId;
    getUserinfo().then((list) {
      this.accessToken = list[0];
      this.userId = list[1];

      print("this code is called");
      getPaymentMethodList();
      getCartSummaryResponse(ownerId: ownerId);
    });
  }

  void selectMethod(int index) {
    selectedPaymentMethod = checkoutModel[index].paymentType.toString();
    selectedPaymentMethodKey = checkoutModel[index].paymentTypeKey.toString();
    notifyListeners();
  }

  Future getPaymentMethodList({String mode = ""}) async {
    try {
      var caller = await MyClient.get(endpoint: "/payment-types/$userId");
      // var caller = await MyClient.get(endpoint: "/payment-types");
      paymentOptions = (jsonDecode(caller.body) as List)
          .map((ob) => PaymentMethodResponse.fromJson(ob))
          .toList();

      paymentOptions!.forEach((ob) {
        print(ob.paymentType);
        checkoutModel.add(CheckoutModel(
            name: ob.name,
            image: ob.image,
            title: ob.title,
            paymentType: ob.paymentType,
            paymentTypeKey: ob.paymentTypeKey));
        notifyListeners();
      });
    } catch (e) {}
  }

  Future getCartSummaryResponse({required String ownerId}) async {
    try {
      var caller = await MyClient.get(
        endpoint: "/cart-summary/" + userId.toString() + "/" + ownerId,
      );

      checkoutSummaryResponse =
          CheckoutSummaryResponse.fromJson(jsonDecode(caller.body));
      print(checkoutSummaryResponse?.toJson());

      notifyListeners();
    } catch (e) {}
  }

  Future<int> createOrder({required String paymentMethod}) async {
    var postBody = {
      "owner_id": ownerId,
      "user_id": userId,
      "payment_type": paymentMethod
    };

    try {
      var caller = await MyClient.post(
        endpoint: "/order/store",
        bodyData: postBody,
      );

      createResponse = OrderCreateResponse.fromJson(jsonDecode(caller.body));
      if (createResponse!.result) {
        Provider.of<AppProvider>(context, listen: false).getTotalItemsinCart();
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future createOrderFromCod({required paymentMethod}) async {
    var postBody = {
      "owner_id": ownerId,
      "user_id": userId,
      "payment_type": paymentMethod
    };

    try {
      var caller = await MyClient.post(
        endpoint: "/payments/pay/cod",
        bodyData: postBody,
      );
      print(postBody);
      print(caller.body);
      createResponse = OrderCreateResponse.fromJson(jsonDecode(caller.body));
      Provider.of<AppProvider>(context, listen: false).getTotalItemsinCart();
    } catch (e) {}
  }

  Future applyCoupon({required String couponCode}) async {
    try {
      var caller = await MyClient.post(endpoint: "/coupon-apply", bodyData: {
        "owner_id": ownerId,
        "user_id": userId,
        "coupon_code": couponCode
      });
      var response = CommonResponse.fromJson(jsonDecode(caller.body));
      Toast.createToast(
          context: context,
          message: response.message.toString(),
          duration: Duration(milliseconds: 1500));
    } catch (e) {}
  }

  Future getUserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));
    return holder;
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}
