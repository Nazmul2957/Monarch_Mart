import 'package:flutter/material.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class CommonWebView extends StatelessWidget {
  String url, title;

  CommonWebView({required this.url, required this.title});
  late double width, height;
  late WebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: Myappbar(context).appBarCommon(title: title),
          body: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              webViewController = controller;
              webViewController.loadUrl(url);
            },
            onWebResourceError: (error) {},
            onPageFinished: (page) {
              //print(page.toString());
            },
          )),
    );
  }
}
