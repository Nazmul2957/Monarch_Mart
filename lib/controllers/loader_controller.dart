import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_models/mToken.dart';
import 'package:monarch_mart/app_utils/utlis.dart';

import '../app_components/app_constant.dart';

class LoaderController extends GetxController {
  final loginLoader = false.obs;
  final otpVerifyLoader = false.obs;
  final cartLoader = false.obs;
  final orderLoader = false.obs;
  final confirmOrderLoader = false.obs;
  final paymentLoader = false.obs;
  final profileUpdateLoader = false.obs;
  final isBuyNow = false.obs;

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('token==>$token');
    if (token != null && token.isNotEmpty) {
      saveToken(token);
    }
  }

  saveToken(String token) async {
    String userId = await getStringSP(AppConstant.USER_ID);
    String userName = await getStringSP(AppConstant.USER_NAME);
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.==>${userCredential.user?.uid}");
      if (userId.isNotEmpty) {
        print('userId ==>$userId');
        final docUser =
            FirebaseFirestore.instance.collection('tokens').doc(userId);
        final json = MToken(
                id: userId,
                userName: userName,
                token: token,
                modifiedAt: DateTime.now())
            .toJson();
        docUser
            .set(json)
            .then((value) => print("Token saved"))
            .catchError((error) => print("Failed to token save: $error"));
      } else
        print('userId null');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  refreshToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      print('fcmToken==>$fcmToken');
      if (fcmToken.isNotEmpty) {
        saveToken(fcmToken);
      }
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
  }
}
