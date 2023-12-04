import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/login_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/app_utils/utlis.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_components/app_route.dart';
import '../app_models/register_response.dart';
import '../app_models/screen_aguments.dart';
import '../controllers/loader_controller.dart';

class LoginProvider extends ChangeNotifier {
  final LoaderController loginController = Get.find();
  LoginResponse? response;

  RegisterResponse? regresponse;
  late BuildContext context;

  // var progrss = NetworkProgress();
  bool isnotInitialized = true;

  init({required BuildContext context}) {
    this.context = context;
    isnotInitialized = false;
  }

  setLoginMethod(String method) {
    notifyListeners();
  }

  void validateAndLogin({required String phoneEmail}) {
    if (phoneEmail.isNotEmpty) {
      //
      bool isValid = false;
      if (RegExp(r"(\+8801[3-9][0-9]{8})$").hasMatch(phoneEmail)) {
        isValid = true;
      } else if (RegExp(r"(01[3-9][0-9]{8})$").hasMatch(phoneEmail)) {
        isValid = true;
        phoneEmail = '+88$phoneEmail';
      } else if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(phoneEmail)) {
        isValid = true;
      }

     // print("phoneOrEmail: $phoneEmail");

      if (isValid) {
        loginController.loginLoader.value = true;
        postPhoneToServer(phone: phoneEmail).then((value) {
          print('respnse: $value');
          switch (value) {
            case AppConstant.SUCCESS:
              toast(regresponse?.message ?? "");
              saveSP(AppConstant.USER_ID, regresponse!.userId.toString());
              // saveSP(AppConstant.USER_NAME, phoneEmail);
              loginController.getToken();
              loginController.refreshToken();
              Navigator.pushReplacementNamed(context, AppRoute.otp,
                  arguments: ScreenArguments(data: {
                    "method": "phone",
                    "emailOrphone": phoneEmail,
                    "userId": regresponse?.userId.toString()
                  }));

              break;
            case AppConstant.FAILED:
              loginController.loginLoader.value = false;
              toast(regresponse?.message.toString() ?? "");
              break;
            default:
              loginController.loginLoader.value = false;
              toast("Network Error");
              break;
          }
        });
      } else {
        Toast.createToast(
            context: context,
            message: "Please enter a valid phone or email",
            duration: Duration(seconds: 1));
      }
      //
    } else {
      Toast.createToast(
          context: context,
          message: "Phone Can't be empty!!",
          duration: Duration(seconds: 1));
    }
  }

  toast(String message) {
    Toast.createToast(
        context: context, message: message, duration: Duration(seconds: 1));
  }

  getLogin(
      {required String phoneOrEmail,
      required String password,
      required BuildContext context}) {
    this.context = context;

    // progrss.showProgress(context);
    postDataToServer(phoneOrEmail: phoneOrEmail, password: password)
        .then((value) {
      switch (value) {
        case AppConstant.SUCCESS:
          if (response?.user?.id == null || response?.accessToken == null) {
            Toast.createToast(
                context: context,
                message: "Login Failed",
                duration: Duration(milliseconds: 1000));
            break;
          }

          Provider.of<AppProvider>(context, listen: false).setCredentials(
              userId: response!.user!.id.toString(),
              accessToken: response!.accessToken!,
              userName: response?.user?.name ?? "User",
              userEmail: response?.user?.email ?? "",
              userAvater: response?.user?.avatarOriginal == null
                  ? ""
                  : response!.user!.avatarOriginal.toString(),
              password: password);

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
      // progrss.closeDialog();
    });
  }

  Future<int?> postDataToServer(
      {required String phoneOrEmail, required String password}) async {
    loginController.loginLoader.value = true;
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
      loginController.loginLoader.value = false;
      if (response!.result!) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> postPhoneToServer({required String phone}) async {
    var postBody = {
      "name": "",
      "email_or_phone": phone,
      "password": "",
      "register_by": "phone",
    };

    print(postBody);
    try {
      var caller =
          await MyClient.post(endpoint: "/auth/signup", bodyData: postBody);
      regresponse = RegisterResponse.fromJson(jsonDecode(caller.body));
      loginController.loginLoader.value = false;
      if (regresponse?.result ?? false) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  @override
  // ignore: must_call_super
  void dispose() {
    print("Login provider dispose");
  }
}
