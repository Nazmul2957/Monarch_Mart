// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/cart/checkout/ucb/ucb_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class Ucb extends StatefulWidget {
  String? ownerId;
  String? amount;
  String? orderId;
  String? paymentType;
  String? paymentMethodKey;

  Ucb(
      {this.ownerId = "",
      this.amount = "",
      this.paymentType = "",
      this.paymentMethodKey = "",
      this.orderId = ""});

  @override
  State<Ucb> createState() => _UcbState();
}

class _UcbState extends State<Ucb> {
  late UcbProvider provider;

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
    this.context = context;
    provider = Provider.of<UcbProvider>(context, listen: false);
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
          appBar: Myappbar(context).appBarCommon(title: "UCB"),
          body: Consumer<UcbProvider>(
            builder: (context, ob, child) {
              if (ob.initialUrl != null) {
                log('UCB: ${ob.initialUrl}');
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
                        print('nagod: $page');
                        if (page.contains('/ucb/approved')) {
                          toast('Payment successful');
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRoute.profile, (route) => false);
                          Navigator.pushNamed(context, AppRoute.order);
                          // getData();
                        } else if (page.contains('ucb/cancelled') ||
                            page.contains('ucb/declined')) {
                          toast('Payment failed');
                          Navigator.pop(context);

                          print('failed');
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
        onPaymentSuccess(paymentDetails);
      }
    });
  }

  void onPaymentSuccess(paymentDetails) async {
    provider
        .nagadPaymentProcess(
            paymentType: widget.paymentType,
            amount: widget.amount!,
            orderId: widget.orderId!,
            paymentDetails: paymentDetails)
        .then((value) {
      if (!value) {
        toast(provider.commonResponse?.message.toString() ?? "");

        Navigator.pushNamed(context, AppRoute.order);
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
