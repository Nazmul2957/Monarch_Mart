import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monarch_mart/cart/checkout/upay/upay_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app_components/app_route.dart';
import '../../../app_utils/appbar.dart';
import '../../../app_utils/toast.dart';

class Upay extends StatefulWidget {
  String? ownerId;
  String? amount;
  String? orderId;
  String? paymentType;
  String? paymentMethodKey;
  Upay(
      {this.ownerId = "",
        this.amount = "",
        this.paymentType = "",
        this.paymentMethodKey = "",
        this.orderId = ""});

  @override
  State<Upay> createState() => _UpayState();
}

class _UpayState extends State<Upay> {
  late UpayProvider provider;

  late WebViewController webViewController;

  late BuildContext context;

  late double width, height, statusbar;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  /*  if (Platform.isAndroid) WebView.platform = AndroidWebView();*/
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    provider = Provider.of<UpayProvider>(context, listen: false);
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
          appBar: Myappbar(context).appBarCommon(title: "Uapy"),
          body: Consumer<UpayProvider>(
            builder: (context, ob, child) {
              if (ob.initialUrl != null) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 5),
                    width: width * 100,
                    height: height * 100,
                    child: WebView(
                      debuggingEnabled: false,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                        webViewController.loadUrl(ob.initialUrl!);
                      },
                      onWebResourceError: (error) {},
                      onPageFinished: (page) {
                        print("PAGE: $page");
                        if (page.contains('upay-payment-status') &&
                            page.contains('status=successful')) {
                          toast('Payment successful');
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRoute.profile, (route) => false);
                          Navigator.pushNamed(context, AppRoute.order);
                          // getData();
                        } else if (page.contains('upay-payment-status') &&
                            page.contains('status=failed')) {
                          toast('Payment failed');
                          Navigator.pop(context);

                          print('failed');
                        } else if (page.contains('upay-payment-status') &&
                            page.contains('status=cancel')) {
                          toast('Payment cancel');
                          Navigator.pop(context);

                          print('failed');
                        }

                        // if (page.contains("/upay/verify/") ||
                        //     page.contains('/check-out/confirm-payment/')) {
                        //   Navigator.pushNamedAndRemoveUntil(
                        //       context, AppRoute.profile, (route) => false);
                        //   Navigator.pushNamed(context, AppRoute.order);
                        //   getData();
                        // } else {
                        //
                        // }
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
  toast(String message) {
    Toast.createToast(
        context: context,
        message: message,
        duration: Duration(milliseconds: 1500));
  }
}
