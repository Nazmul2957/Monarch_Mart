import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/register_response.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';

class RegistrationProvider extends ChangeNotifier {
  late BuildContext context;
  bool isInitialize = false;

  // var progrss = NetworkProgress();
  RegisterResponse? response;
  bool canPostData = true;

  init({required BuildContext context}) {
    this.context = context;
  }

  String regMethod = "email";

  setRegisterMethod(String method) {
    this.regMethod = method;
    notifyListeners();
  }

  void validateAndRegister(
      {required String name,
      required String phoneEmail,
      required String password,
      required String confirmPassword}) {
    if (name.isNotEmpty) {
      if (phoneEmail.isNotEmpty) {
        if (password.isNotEmpty) {
          if (confirmPassword.isNotEmpty) {
            if (password.compareTo(confirmPassword) == 0) {
              bool isValid = false;
              if (RegExp(r"(\+8801[3-9][0-9]{8})$").hasMatch(phoneEmail)) {
                isValid = true;
                regMethod = "phone";
              } else if (RegExp(r"(01[3-9][0-9]{8})$").hasMatch(phoneEmail)) {
                isValid = true;
                phoneEmail = '+88$phoneEmail';
                regMethod = "phone";
              } else if (RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(phoneEmail)) {
                isValid = true;
              }

              print("phoneOrEmail: $phoneEmail");

              if (isValid) {
                register(
                    name: name, emailorPhone: phoneEmail, password: password);
              } else {
                Toast.createToast(
                    context: context,
                    message: "Please enter a valid phone or email",
                    duration: Duration(seconds: 1));
              }
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
        toast("Phone or Email Can't be Empty");
      }
    } else {
      toast("Name Can't be Empty");
    }
  }

  void register(
      {required String name,
      required String emailorPhone,
      required String password}) {
    // progrss.showProgress(context);

    postDataToServer(name: name, emailorPhone: emailorPhone, password: password)
        .then((value) {
      // progrss.closeDialog();
      switch (value) {
        case AppConstant.SUCCESS:
          print(response!.toJson());
          toast(response!.message.toString());
          Navigator.pushReplacementNamed(context, AppRoute.otp,
              arguments: ScreenArguments(data: {
                "method": regMethod,
                "emailOrphone": emailorPhone,
                "userId": response!.userId.toString()
              }));

          break;
        case AppConstant.FAILED:
          toast(response!.message.toString());
          break;
        default:
          toast("Network Error");
          break;
      }
    });
  }

  Future<int> postDataToServer(
      {required String name,
      required String emailorPhone,
      required String password}) async {
    var postBody = {
      "name": name,
      "email_or_phone": emailorPhone,
      "password": "",
      "register_by": "phone",
    };

    print(postBody);
    try {
      var caller =
          await MyClient.post(endpoint: "/auth/signup", bodyData: postBody);
      response = RegisterResponse.fromJson(jsonDecode(caller.body));
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

  @override
  // ignore: must_call_super
  void dispose() {
    print("Registration Provider disposed");
  }
}
