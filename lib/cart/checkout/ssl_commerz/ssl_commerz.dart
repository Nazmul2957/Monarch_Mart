// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/cart/checkout/ssl_commerz/ssl_commerz_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class SSlCommerz extends StatefulWidget {
  String? ownerId;
  String? amount;
  String orderId;
  String? paymentType;
  String? paymentMethodKey;
  SSlCommerz(
      {this.ownerId = "",
      this.amount = "",
      this.paymentType = "",
      this.paymentMethodKey = "",
      required this.orderId});

  @override
  State<SSlCommerz> createState() => _SSlCommerzState();
}

class _SSlCommerzState extends State<SSlCommerz> {
  late SSlCommerzProvider presenter;

  late WebViewController _webViewController;

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
    this.context = context;
    print(widget.orderId);
    presenter = Provider.of<SSlCommerzProvider>(context, listen: false);
    if (!presenter.isInitialize) {
      presenter.init(
          context: context,
          ownerId: widget.ownerId.toString(),
          orderId: widget.orderId.toString(),
          amount: widget.amount.toString(),
          paymentType: widget.paymentType.toString());
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
        appBar: Myappbar(context).appBarCommon(title: "SSlCommerz"),
        body: Consumer<SSlCommerzProvider>(
          builder: (context, ob, child) {
            if (ob.mainUrl != null) {
              return WebView(
                debuggingEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                  _webViewController.loadUrl(presenter.mainUrl.toString());
                },
                onWebResourceError: (error) {},
                onPageFinished: (page) {
                  if (page.contains("/sslcommerz/success")) {
                    toast("Payment Successfull!!!!");
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoute.profile, (route) => false);
                    Navigator.pushNamed(context, AppRoute.order);
                  } else if (page.contains("/sslcommerz/cancel") ||
                      page.contains("/sslcommerz/fail")) {
                    toast("Payment cancelled or failed");
                    Navigator.of(context).pop();
                    return;
                  }
                },
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
        ),
      ),
    );
  }

  void getData() {
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      if (responseJSON["result"] == false) {
        Navigator.pushNamed(context, AppRoute.order);
      } else if (responseJSON["result"] == true) {
        toast(responseJSON["message"]);
        if (widget.paymentType == "cart_payment") {
          toast(responseJSON["message"]);
          Navigator.pop(context);
        } else if (widget.paymentType == "wallet_payment") {
          toast(responseJSON["message"]);
          Navigator.pop(context);
        }
      }
    });
  }

  toast(String message) {
    Toast.createToast(
        context: context,
        message: message,
        duration: Duration(milliseconds: 1500));
  }
}
