import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/login_response.dart';
import 'package:monarch_mart/app_models/otp_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/app_utils/utlis.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/loader_controller.dart';
import '../state_manager/app_provider.dart';

class OtpProvider extends ChangeNotifier {
  final LoaderController loginController = Get.find();
  String? userId;
  late BuildContext context;
  bool isInitialize = false, canResend = false;
  Timer? timer;
  int requiredTimes = 30;
  OtpResponse? verificationResponse, resendResponse;
  String? regMethod;

  // var progrss = NetworkProgress();
  LoginResponse? response;

  init({required BuildContext context, String? userId, String? regMethod}) {
    this.context = context;
    this.userId = userId;
    this.regMethod = regMethod;
    startTimer();
  }

  void confirmVerificationCode(
      {required String userId,
      required String verificationCode,
      required String phone}) {
    this.userId = userId;
    if (!loginController.otpVerifyLoader.value) {
      loginController.otpVerifyLoader.value = true;
      postVerificationCodeToServer(verificationCode: verificationCode)
          .then((value) {
        loginController.otpVerifyLoader.value = false;
        switch (value) {
          case AppConstant.SUCCESS:
            toast(verificationResponse?.message.toString() ?? "");
            getLogin(phoneOrEmail: phone);
            break;
          case AppConstant.FAILED:
            toast(verificationResponse?.message.toString() ?? "");
            break;
          default:
            toast("Network Error!!!");
            break;
        }
      });
    }
  }

  void resendVerificationCode({required String registrationMethod}) {
    if (canResend) {
      canResend = false;
      startTimer();
      postDataToResendVerificationCode(registrationMethod: registrationMethod)
          .then((value) {
        if (value == AppConstant.SUCCESS) {
          toast(resendResponse?.message ?? "");
        }
      });
    } else {
      toast("Please Resend after " + requiredTimes.toString() + " seconds");
    }
  }

  Future<int> postVerificationCodeToServer(
      {required String verificationCode}) async {
    var postBody = {"user_id": userId, "verification_code": verificationCode};

    try {
      var caller = await MyClient.post(
          endpoint: "/auth/confirm_code", bodyData: postBody);
      verificationResponse = OtpResponse.fromJson(jsonDecode(caller.body));
      if (verificationResponse!.result) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> postDataToResendVerificationCode(
      {required String registrationMethod}) async {
    var postBody = {"user_id": userId, "register_by": registrationMethod};
    print(postBody);
    try {
      var caller = await MyClient.post(
        endpoint: "/auth/resend_code",
        bodyData: postBody,
      );
      print(caller.body);
      if (caller.statusCode == 200) {
        resendResponse = OtpResponse.fromJson(jsonDecode(caller.body));
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  getLogin({required String phoneOrEmail}) {
    postToLogin(phoneOrEmail: phoneOrEmail).then((value) async {
      switch (value) {
        case AppConstant.SUCCESS:
          if (response?.user?.id == null || response?.accessToken == null) {
            Toast.createToast(
                context: context,
                message: "Login Failed",
                duration: Duration(milliseconds: 1000));
            break;
          }
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString(
              AppConstant.ACCESS_TOKEN, response?.accessToken ?? "");
          preferences.setString(
              AppConstant.USER_ID, response!.user!.id.toString());
          saveSP(AppConstant.USER_ID, response!.user!.id.toString());
          // saveSP(AppConstant.USER_NAME, phoneOrEmail);
          loginController.getToken();
          loginController.refreshToken();
          Provider.of<AppProvider>(context, listen: false).setCredentials(
              userId: response!.user!.id.toString(),
              accessToken: response!.accessToken!,
              userName: response?.user?.name ?? "User",
              userEmail: response?.user?.email ?? "",
              userAvater: response?.user?.avatarOriginal == null
                  ? ""
                  : response!.user!.avatarOriginal.toString(),
              password: "");

          Navigator.pop(context);

          break;
        case AppConstant.FAILED:
          Toast.createToast(
              context: context,
              message: response!.message!,
              duration: Duration(milliseconds: 1000));

          break;

        default:
          Toast.createToast(
              context: context,
              message: "Network Failure!!!",
              duration: Duration(milliseconds: 1000));
      }
    });
  }

  Future<int?> postToLogin({required String phoneOrEmail}) async {
    var preferences = await SharedPreferences.getInstance();
    String? fcmToken = preferences.getString(AppConstant.FCM_TOKEN);
    if (fcmToken != null || fcmToken != "") {
      fcmToken = await FirebaseMessaging.instance.getToken();
      preferences.setString(AppConstant.FCM_TOKEN, fcmToken ?? "");
    }
    var bodyData = {
      "email": phoneOrEmail,
      "password": "",
      "identity_matrix": AppConstant.purchase_code,
      "device_token": fcmToken,
    };

    try {
      var caller =
          await MyClient.post(endpoint: "/auth/login", bodyData: bodyData);

      response = LoginResponse.fromJson(jsonDecode(caller.body));
      if (response!.result!) {
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

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (requiredTimes >= 1) {
        requiredTimes--;
      } else {
        canResend = true;
        requiredTimes = 30;
        timer.cancel();
      }
    });
  }

  @override
  // ignore: must_call_super
  void dispose() {
    timer?.cancel();
  }
}
