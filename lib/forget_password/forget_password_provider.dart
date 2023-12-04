import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_utils/toast.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  String method = "phone";
  CommonResponse? forgetPasswordResponse;
  late BuildContext context;

  bool isinitialized = false;
  setMethod(String method) {
    this.method = method;
    notifyListeners();
  }

  init({required BuildContext context}) {
    this.context = context;
    isinitialized = true;
  }

  void validateAndPost({required String emailOrPhone}) {
    if (emailOrPhone.isNotEmpty) {
      bool isValid = false;
      if (RegExp(r"(\+8801[3-9][0-9]{8})$").hasMatch(emailOrPhone)) {
        isValid = true;
      } else if (RegExp(r"(01[3-9][0-9]{8})$").hasMatch(emailOrPhone)) {
        isValid = true;
        emailOrPhone = '+88$emailOrPhone';
      } else if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailOrPhone)) {
        isValid = true;
      }
      if (isValid) {
        forgetPassword(emailOrphone: emailOrPhone);
      } else {
        toast("Validation failed!!!");
      }
    } else {
      toast("Phone or Email can't be empty!!");
    }
  }

  void forgetPassword({required String emailOrphone}) {
    postForgotPassword(emailOrphone: emailOrphone, sendCodeBy: method)
        .then((value) {
      switch (value) {
        case AppConstant.SUCCESS:
          toast(forgetPasswordResponse!.message.toString());
          Navigator.pushNamed(context, AppRoute.resetPass);

          break;
        case AppConstant.FAILED:
          toast(forgetPasswordResponse!.message.toString());
          break;
        default:
          toast("Network Error!!!");
          break;
      }
    });
  }

  Future<int> postForgotPassword(
      {required String emailOrphone, required String sendCodeBy}) async {
    try {
      var postBody = jsonEncode(
          {"email_or_phone": emailOrphone, "send_code_by": sendCodeBy});

      var url = Uri.parse(AppUrl.base_url + "/auth/password/forget_request");
      var caller = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: postBody);
      forgetPasswordResponse = CommonResponse.fromJson(jsonDecode(caller.body));

      if (forgetPasswordResponse!.result) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  toast(String message) {
    Toast.createToast(
        context: context, message: message, duration: Duration(seconds: 1));
  }

  @override
  // ignore: must_call_super
  void dispose() {
    print("forget password presenter disposed");
  }
}
