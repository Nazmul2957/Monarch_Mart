// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/orders/order_details/component/nogod_repay.dart';
import 'package:monarch_mart/orders/order_details/component/repay_options.dart';
import 'package:monarch_mart/orders/order_details/component/ssl_repay.dart';
import 'package:monarch_mart/orders/order_details/component/ucb_repay.dart';
import 'package:monarch_mart/orders/order_details/component/upay_repay.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'component/bkash_repay.dart';
import 'component/order_info.dart';
import 'component/ordered_product.dart';
import 'component/time_line_status.dart';
import 'component/total_calculation.dart';
import 'order_details_provider.dart';

class OrderDetails extends StatefulWidget {
  String orderId;

  OrderDetails({required this.orderId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late double width, height, statusbar;

  late OrderDetailsProvider presenter;
  late WebViewController webViewController;

  Future onRefresh() async {}
  late BuildContext mycontext;

  @override
  Widget build(BuildContext context) {
    print(widget.orderId);
    print("order page");
    this.mycontext = context;
    presenter = Provider.of<OrderDetailsProvider>(context, listen: false);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    if (!presenter.initialzed) {
      presenter.init(orderId: widget.orderId);
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Myappbar(context).appBarCommon(title: "Order Details"),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 5),
              child: Column(
                children: [
                  TimeLineStatus(
                      presenter: presenter, width: width, height: height),
                  SizedBox(height: height * 2.5),
                  Consumer<OrderDetailsProvider>(
                    builder: (context, ob, child) {
                      if (ob.response != null) {
                        if (ob.response?.data?[0].paymentStatusString ==
                                "Unpaid" &&
                            ob.response?.data?[0].deliveryStatus !=
                                "cancelled") {
                          return Container(
                            alignment: Alignment.centerRight,
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: AppColor.primary,
                                    fixedSize: Size(100.w, 50.h)),
                                onPressed: () {
                                  repayOptions(presenter.orderId);
                                },
                                child: Text(
                                  "Repay",
                                  style: TextStyle(color: AppColor.white),
                                )),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: height * 2.5),
                  OrderInfo(
                    presenter: presenter,
                    width: width,
                    height: height,
                  ),
                  OrderedProduct(
                      presenter: presenter, width: width, height: height),
                  TotalCalculation(
                      presenter: presenter, width: width, height: height)
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  void repayOptions(String? orderId) {
    showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        builder: (_) => RepayOptions(
              orderId: orderId,
            )).then((String? paymentMethod) {
      if (paymentMethod == "nagad") {
        repayNagad(mycontext, orderId);
      } else if (paymentMethod == "bkash") {
        repayBkash(mycontext, orderId);
      } else if (paymentMethod == "upay") {
        repayUpay(mycontext, orderId);
      } else if (paymentMethod == "sslcommerz_payment") {
        repaySsl(mycontext, orderId);
      } else if (paymentMethod == "ucb_bank") {
        repayUcb(mycontext, orderId);
      } else {
        print("no payment method for $paymentMethod");
      }

      print(paymentMethod);
      print("payment method");
    });
  }

  void repayNagad(BuildContext context, String? orderId) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        builder: (_) => NogodRepay(orderId: orderId));
  }

  void repayBkash(BuildContext context, String? orderId) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        builder: (_) => BkashRepay(orderId: orderId));
  }

  void repayUcb(BuildContext context, String? orderId) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        builder: (_) => UcbRepay(orderId: orderId));
  }

  void repayUpay(BuildContext context, String? orderId) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        builder: (_) => UpayRepay(orderId: orderId));
  }

  void repaySsl(BuildContext context, String? orderId) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r))),
        builder: (_) => SslRepay(orderId: orderId));
  }
}
