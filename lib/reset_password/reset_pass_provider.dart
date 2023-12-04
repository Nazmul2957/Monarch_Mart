import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_utils/toast.dart';

class ResetPasswordProvider extends ChangeNotifier {
  late BuildContext context;
  bool isinitialized = false;
  CommonResponse? resetResponse;
  init({required BuildContext context}) {
    this.context = context;
    isinitialized = true;
  }

  void validateAndPost(
      {required String verificationCode,
      required String password,
      required String confirmPassword}) {
    if (verificationCode.isNotEmpty) {
      if (password.isNotEmpty) {
        if (confirmPassword.isNotEmpty) {
          if (password.compareTo(confirmPassword) == 0) {
            resetPassword(
                verificationCode: verificationCode, password: password);
          } else {
            toast("Password Doesn't Match");
          }
        } else {
          toast("Retype Password");
        }
      } else {
        toast("Enter Password");
      }
    } else {
      toast("Verification code Can't be empty");
    }
  }

  void resetPassword(
      {required String verificationCode, required String password}) {
    postToResetPassword(verificationCode: verificationCode, password: password)
        .then((value) {
      switch (value) {
        case AppConstant.SUCCESS:
          toast(resetResponse!.message!);
          for (var i = 0; i < 2; i++) {
            Navigator.pop(context);
          }
          break;
        case AppConstant.FAILED:
          toast(resetResponse!.message.toString());
          break;
        default:
          toast("Network Error!!!");
          break;
      }
    });
  }

  Future<int> postToResetPassword(
      {required String verificationCode, required String password}) async {
    try {
      var postBody = jsonEncode(
          {"verification_code": verificationCode, "password": password});
      var url = Uri.parse(AppUrl.base_url + "/auth/password/confirm_reset");

      var caller = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: postBody);
      resetResponse = CommonResponse.fromJson(jsonDecode(caller.body));
      if (resetResponse!.result) {
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
  void dispose() {}
}
