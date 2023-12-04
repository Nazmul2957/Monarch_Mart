// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bkash_provider.dart';

// ignore: must_be_immutable
class Bkash extends StatefulWidget {
  String? ownerId;
  String? amount;
  String? orderId;
  String? paymentType;
  String? paymentMethodKey;

  Bkash(
      {this.ownerId = "",
      this.amount = "",
      this.paymentType = "",
      this.paymentMethodKey = "",
      this.orderId = ""});

  @override
  State<Bkash> createState() => _BkashState();
}

class _BkashState extends State<Bkash> {
  late BkashProvider provider;

  late WebViewController webViewController;

  late BuildContext context;

  late double width, height, statusbar;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
   /* if (Platform.isAndroid) WebView.platform = AndroidWebView();*/
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BkashProvider>(context, listen: false);
    if (!provider.isInitialize) {
      provider.init(
          context: context,
          ownerId: widget.ownerId!,
          orderId: widget.orderId!,
          amount: widget.amount!,
          paymentType: widget.paymentType!);
    }
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: Myappbar(context).appBarCommon(title: "Bkash"),
          body: Consumer<BkashProvider>(
            builder: (context, ob, child) {
              if (ob.initialUrl != null) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 5),
                    width: width * 100,
                    height: height * 100,
                    child: WebView(
                      debuggingEnabled: false,
                      zoomEnabled: true,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                        webViewController.loadUrl(ob.initialUrl!);
                      },
                      onWebResourceError: (error) {},
                      onPageFinished: (page) {
                        print('bkash__$page');
                        if (page.contains('/bkash/api/success')) {
                          toast(context, 'Payment successful');
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRoute.profile, (route) => false);
                          Navigator.pushNamed(context, AppRoute.order);
                          // getData();
                        } else if (page.contains('/bkash/api/fail')) {
                          print('failed');
                          toast(context, 'Payment failed');
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                );
              } else {
                return Center(
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
                );
              }
            },
          )),
    );
  }

  // void getData() {
  toast(BuildContext context, String message) {
    Toast.createToast(
        context: context,
        message: message,
        duration: Duration(milliseconds: 1500));
  }
}
