// ignore_for_file: unnecessary_null_comparison, must_call_super

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:monarch_mart/app_models/all_offer_response.dart';
import 'package:monarch_mart/core/app_export.dart';

class AllOfferProvider extends ChangeNotifier {
  AllOfferResponse? response;
  int defaultLength = 3;
  List<CountdownTimerController> timerControllerList = [];
  DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }

  String timeText(String txt, {defaultLength = 3}) {
    var blankZeros = defaultLength == 3 ? "000" : "00";
    var leadingZeros = "";
    if (txt != null) {
      if (defaultLength == 3 && txt.length == 1) {
        leadingZeros = "00";
      } else if (defaultLength == 3 && txt.length == 2) {
        leadingZeros = "0";
      } else if (defaultLength == 2 && txt.length == 1) {
        leadingZeros = "0";
      }
    }
    var newtxt =
        (txt == null || txt == "" || txt == null.toString()) ? blankZeros : txt;

    if (defaultLength > txt.length) {
      newtxt = leadingZeros + newtxt;
    }

    return newtxt;
  }

  Future getFlashDealProduct() async {
    try {
      var caller = await MyClient.get(endpoint: "/flash-deals");
      if (caller.statusCode == 200) {
        response = AllOfferResponse.fromJson(jsonDecode(caller.body));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {}
}
