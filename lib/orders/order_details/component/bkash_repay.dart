// ignore_for_file: must_be_immutable, unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/bkash_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app_components/app_route.dart';
import '../../../app_utils/toast.dart';

class BkashRepay extends StatefulWidget {
  String? orderId;

  BkashRepay({required this.orderId});

  @override
  State<BkashRepay> createState() => _BkashRepayState();
}

class _BkashRepayState extends State<BkashRepay> {
  late double width, height, statusbar;
  late WebViewController webViewController;
  String? initialUrl;
  BkashResponse? nagadResponse;

  @override
  void initState() {
    super.initState();
    getBkashInitials(orderId: widget.orderId);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: Container(
        height: 800.h,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
        ),
        child: initialUrl != null
            ? SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 5),
                  width: width * 100,
                  height: height * 100,
                  child: WebView(
                    debuggingEnabled: false,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                      webViewController.loadUrl(initialUrl!);
                    },
                    onWebResourceError: (error) {},
                    onPageFinished: (page) {
                      if (page.contains('/bkash/api/success')) {
                        toast('Payment successful');
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoute.profile, (route) => false);
                        Navigator.pushNamed(context, AppRoute.order);
                        // getData();
                      } else if (page.contains('/bkash/api/fail')) {
                        toast('Payment failed');
                        Navigator.pop(context);

                        print('failed');
                      }
                    },
                  ),
                ),
              )
            : Center(
                child: Container(
                  width: width * 35,
                  height: width * 35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: width * 25,
                        height: width * 25,
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xff1EC93C),
                          strokeWidth: width * 3,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: width * 15,
                          height: width * 15,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            "Fetching Data..",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void getData() {
    var paymentDetails = '';
    webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      print(data.toString());
      if (responseJSON["result"] == false) {
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        paymentDetails = responseJSON['payment_details'];
      }
    });
  }

  Future<int> getBkashInitials({required String? orderId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      var url = Uri.parse(AppUrl.base_url +
          "/bkash/begin?payment_type=single_order_payment&order_id=$orderId");
      print(url);
      print(preferences.getString(AppConstant.ACCESS_TOKEN) ?? "");
      var caller = await http.get(
        url,
        headers: {
          "Authorization": "Bearer " +
              (preferences.getString(AppConstant.ACCESS_TOKEN) ?? ""),
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      print(caller.body);
      nagadResponse = BkashResponse.fromJson(jsonDecode(caller.body));

      if (nagadResponse!.result!) {
        setState(() {
          initialUrl = nagadResponse?.url ?? "";
        });
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
        context: context,
        message: message,
        duration: Duration(milliseconds: 1500));
  }
}
