import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_models/common_response.dart';
import 'package:monarch_mart/app_models/profile_update_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/loader_controller.dart';

class ProfileEditProvider extends ChangeNotifier {
  final LoaderController loaderController = Get.find();
  String? userId, accessToken, userPassword, userName, avater;
  bool isInitialize = false;
  late BuildContext context;
  ProfileImageUpdateresponse? imageResponse;
  CommonResponse? editResponse;
  late AppProvider provider;

  init({required BuildContext context}) {
    provider = Provider.of<AppProvider>(context, listen: false);

    avater = provider.userAvter.toString();
    userId = provider.userId.toString();
    userName = provider.userName.toString();
    userPassword = provider.password.toString();
    accessToken = provider.accessToken.toString();
    this.context = context;
    isInitialize = true;
  }

  updateImage({required String image, required String filename}) {
    // var progress = NetworkProgress();
    // progress.showProgress(context);

    postProfilePicData(image: image, filename: filename).then((value) {
      switch (value) {
        case AppConstant.SUCCESS:
          Toast.createToast(
              context: context,
              message: imageResponse!.message.toString(),
              duration: Duration(seconds: 1));

          break;
        case AppConstant.FAILED:
          Toast.createToast(
              context: context,
              message: imageResponse!.message.toString(),
              duration: Duration(seconds: 1));
          break;
        default:
          Toast.createToast(
              context: context,
              message: "Network Error",
              duration: Duration(seconds: 1));
          break;
      }
      // progress.closeDialog();
      notifyListeners();
    });
  }

  updateProfile({required String name, required String password}) {
    if (!loaderController.profileUpdateLoader.value) {
      loaderController.profileUpdateLoader.value = true;
      postProfileInformationData(name: name, password: password).then((value) {
        loaderController.profileUpdateLoader.value = false;
        switch (value) {
          case AppConstant.SUCCESS:
            provider.updateName(name);
            Toast.createToast(
                context: context,
                message: editResponse!.message.toString(),
                duration: Duration(seconds: 1));
            notifyListeners();
            break;
          case AppConstant.FAILED:
            Toast.createToast(
                context: context,
                message: editResponse!.message.toString(),
                duration: Duration(seconds: 1));
            break;
          default:
            Toast.createToast(
                context: context,
                message: "Network Error",
                duration: Duration(seconds: 1));
            break;
        }
        notifyListeners();
      });
    }
  }

  Future<int> postProfileInformationData(
      {required String name, required String password}) async {
    try {
      var caller = await MyClient.post(
        endpoint: "/profile/update",
        bodyData: {"id": userId, "name": name, "password": password},
      );
      editResponse = CommonResponse.fromJson(jsonDecode(caller.body));

      if (editResponse!.result) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> postProfilePicData(
      {required String image, required String filename}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      var caller = await MyClient.post(
        endpoint: "/profile/update-image",
        bodyData: {"id": userId, "image": image, "filename": filename},
      );

      imageResponse =
          ProfileImageUpdateresponse.fromJson(jsonDecode(caller.body));
      provider.updatePhoto((imageResponse?.path ?? ""));
      if (imageResponse!.result) {
        avater = imageResponse!.path.toString();
        preferences.setString(AppConstant.USER_AVETER, avater.toString());
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  String validator(String name, String password, String confirmpassword) {
    if (name.isNotEmpty) {
      if (password.compareTo(confirmpassword) == 0) {
        return "true";
      } else {
        return "Type Both password correctly";
      }
    } else {
      return "Name Empty !!";
    }
  }
}
