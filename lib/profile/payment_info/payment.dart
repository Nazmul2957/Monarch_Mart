import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/wallet_recharge_response.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/loading_progress.dart';
import 'package:provider/provider.dart';

import 'payment_provider.dart';

// ignore: must_be_immutable
class Payment extends StatelessWidget {
  late PaymentProvider presenter;
  late double width, height, statusbar;
  ScrollController rechargeScrollController = ScrollController();
  late BuildContext context;

  initializer() {
    rechargeScrollController.addListener(() {
      if (rechargeScrollController.position.pixels ==
          rechargeScrollController.position.maxScrollExtent) {
        if (presenter.page < presenter.rechargeResponse!.meta!.lastPage) {
          LoadingProgrss.showProgress(context);
          presenter.nextPage();
        } else {
          toast();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    presenter = Provider.of<PaymentProvider>(context, listen: false);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;

    if (!presenter.isInitialized) {
      presenter.init();
      initializer();
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Myappbar(context).appBarCommon(title: "My Wallet"),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              balanceLastRecharge(),
              SizedBox(height: height * 2),
              addRecharge(),
              SizedBox(height: height),
              rechargeHistory(),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  Widget balanceLastRecharge() {
    return Consumer<PaymentProvider>(
      builder: (context, ob, child) {
        if (ob.balanceResponse != null) {
          return Container(
            height: height * 20,
            width: width * 90,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(height)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wallet Balance",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: height * 2, color: Colors.white)),
                SizedBox(height: height * 2),
                Text(ob.balanceResponse!.balance.toString(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: height * 2.8, color: Colors.white)),
                SizedBox(height: height * 2),
                Text(
                    "Last Recharged : " +
                        ob.balanceResponse!.lastRecharged.toString(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: height * 1.4, color: Colors.white)),
              ],
            ),
          );
        } else {
          return AppShimer(
            width: width * 90,
            height: height * 20,
            borderRadius: height,
          );
        }
      },
    );
  }

  Widget addRecharge() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width * 90, height * 5), primary: AppColor.primary),
        onPressed: () {},
        child: Icon(Icons.add, size: height * 4, color: AppColor.white));
  }

  Widget rechargeHistory() {
    return Consumer<PaymentProvider>(
      builder: (context, ob, child) {
        if (ob.rechargeResponse != null) {
          if (ob.rechargeResponse!.data!.isNotEmpty) {
            return Expanded(
                child: RefreshIndicator(
                    color: AppColor.secondary,
                    backgroundColor: Colors.white,
                    onRefresh: onRefresh,
                    child: ListView.builder(
                        controller: rechargeScrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: ob.rechargeResponse!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(vertical: height),
                              child: rechargeHistoryItemBlock(
                                  ob.rechargeResponse, index));
                        })));
          } else {
            return Center(child: Text("No recharge history available"));
          }
        } else {
          return shimerList();
        }
      },
    );
  }

  Widget rechargeHistoryItemBlock(
      WalletRechargeResponse? rechargeResponse, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 2, vertical: height),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          border: Border.all(
              color: Colors.black.withOpacity(0.5), width: width / 6)),
      child: Row(
        children: [
          Container(
            width: width * 10,
            alignment: Alignment.topCenter,
            child: Text(
              getFormatted(index),
              style: TextStyle(
                  fontSize: height * 1.6,
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: width * 36,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(rechargeResponse!.data![index].date.toString(),
                    style: TextStyle(
                        fontSize: height * 1.7,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),
                Text("Payment Method",
                    style: TextStyle(
                        fontSize: height * 1.6,
                        color: Colors.black.withOpacity(0.6))),
                Text(rechargeResponse.data![index].paymentMethod.toString(),
                    style: TextStyle(
                        fontSize: height * 1.7,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            width: width * 36,
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(rechargeResponse.data![index].amount.toString(),
                    style: TextStyle(
                        fontSize: height * 2.2,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600)),
                Text("Approval Status",
                    style: TextStyle(
                        fontSize: height * 1.6,
                        color: Colors.black.withOpacity(0.6))),
                Text(rechargeResponse.data![index].approvalString.toString(),
                    style: TextStyle(
                        fontSize: height * 1.7,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getFormatted(int index) {
    int num = index + 1;
    var txt = num.toString().length == 1
        ? "# 0" + num.toString()
        : "#" + num.toString();
    return txt;
  }

  Widget shimerList() {
    return Expanded(
      child: ListView.builder(
          itemCount: 10,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: height / 2),
                child: AppShimer(width: width * 90, height: height * 10),
              )),
    );
  }

  Future onRefresh() async {}

  void toast() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Container(
        height: height * 4.5,
        child: Center(
          child: Text(
            "No More Data to load",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ));
  }
}
