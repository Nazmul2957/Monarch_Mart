import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/global_variable.dart';
import 'package:monarch_mart/notification_service/Payload.dart';

class LocalNotificationService {
  late BuildContext context;
  static final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    notificationPlugin.initialize(
      initializationSettings,
      onSelectNotification: (jsonOb) {
        Payload payload = Payload.fromJson(jsonDecode(jsonOb.toString()));

        if (payload.type == "deals") {
          Navigator.pushNamed(
              GlobalVariable.navState.currentContext!, AppRoute.product,
              arguments: ScreenArguments(data: {
                "url": payload.clickAction.toString(),
                "category": "Offers",
                "numberofChildren": 0,
                "subcategoryUrl": ""
              }));
        } else {
          Navigator.pushNamed(
              GlobalVariable.navState.currentContext!, AppRoute.order);
        }
      },
    );
  }

  static void createNotification(RemoteMessage message, Payload payload) async {
    var bigPicture;
    var bigPictureInformation;
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (payload.image != null && payload.image!.isNotEmpty) {
      var response = await http.get(Uri.parse(payload.image!));
      bigPicture = ByteArrayAndroidBitmap(response.bodyBytes);
      bigPictureInformation = BigPictureStyleInformation(
        bigPicture ?? null,
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        contentTitle: message.notification?.title,
        summaryText: message.notification?.body,
      );
    }

    final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      "tattuclient",
      "Tattu client channel",
      channelDescription: "This is tattu client channel",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: "@mipmap/ic_launcher",
      styleInformation: bigPictureInformation,
    ));

    await notificationPlugin.show(id, message.notification?.title,
        message.notification?.body, notificationDetails,
        payload: jsonEncode(payload));
  }
}
