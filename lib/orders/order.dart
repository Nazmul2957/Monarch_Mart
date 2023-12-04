import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/order_response.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/loading_progress.dart';
import 'package:monarch_mart/orders/order_provider.dart';
import 'package:provider/provider.dart';

import 'components/dropdown_bar.dart';

// ignore: must_be_immutable
class Order extends StatelessWidget {
  late double width, height, statusbar;
  late BuildContext context;
  late OrderProvider presenter;

  ScrollController orderScrollController = new ScrollController();

  Future onRefresh() async {
    presenter.refresh();
  }

  initializer() {
    orderScrollController.addListener(() {
      if (orderScrollController.position.pixels ==
          orderScrollController.position.maxScrollExtent) {
        if (presenter.page < presenter.orderResponse!.meta!.lastPage) {
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
    presenter = Provider.of<OrderProvider>(context, listen: false);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    if (!presenter.isInitialize) {
      presenter.init();
      initializer();
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Myappbar(context).appBarCommon(title: "Purchase History"),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all()
                      ),
                      child: Text(
                        "All",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 1.0,),
                  Expanded(
                    child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all()
                      ),
                      child: Text("Paid",  style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),),
                    ),
                  ),
                  SizedBox(width: 1.0,),
                  Expanded(
                    child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all()
                      ),
                      child: Text("Unpaid",  style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),),
                    ),
                  ),
                  SizedBox(width: 1.0,),
                  Expanded(
                    child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all()
                      ),
                      child: Text("Confirm",  style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),),
                    ),
                  ),
                  SizedBox(width: 1.0,),
                  Expanded(
                    child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all()
                      ),
                      child: Text("Delivered",  style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),),
                    ),
                  ),
                ],
              ),
              // Dropdownbar(presenter: presenter, height: height, width: width),
              SizedBox(height: height * 2),
              orderList(),
              SizedBox(height: height * 3),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  Widget orderList() {
    return Consumer<OrderProvider>(
      builder: (context, ob, child) {
        if (ob.orderResponse != null) {
          if (ob.orderResponse!.data!.isNotEmpty) {
            return Expanded(
                child: RefreshIndicator(
                    color: AppColor.secondary,
                    backgroundColor: Colors.white,
                    onRefresh: onRefresh,
                    child: ListView.builder(
                        controller: orderScrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: ob.orderResponse!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: height),
                            child: orderBlock(ob.orderResponse!.data![index]),
                          );
                        })));
          } else {
            return Expanded(child: Center(child: Text("No Orders available")));
          }
        } else {
          return shimerList();
        }
      },
    );
  }

  Widget orderBlock(Data data) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoute.orderDetails,
            arguments: ScreenArguments(data: {"orderId": data.id.toString()}));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height),
            border: Border.all(color: AppColor.primary, width: width / 8)),
        padding: EdgeInsets.symmetric(horizontal: width * 2, vertical: height),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width * 55,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  codeWidget(data.code.toString()),
                  dateWidget(data.date.toString()),
                  paymentStatustWidget(data.paymentStatusString.toString()),
                  orderStatusWidget(data.deliveryStatusString.toString())
                ],
              ),
            ),
            Container(
              width: width * 30,
              alignment: Alignment.center,
              child: Text(data.grandTotal.toString(),
                  style: TextStyle(
                      fontSize: height * 1.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }

  Widget codeWidget(String code) {
    return Container(
      width: width * 55,
      height: height * 3,
      child: Text(
        code,
        style: TextStyle(
            fontSize: height * 1.6,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  Widget dateWidget(String date) {
    return Container(
      width: width * 55,
      height: height * 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: height * 2),
          SizedBox(width: width),
          Text(
            date,
            style: TextStyle(fontSize: height * 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget paymentStatustWidget(String status) {
    return Container(
      width: width * 55,
      height: height * 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.credit_card, size: height * 2),
          SizedBox(width: width),
          Text(
            "Payment Status- " + status,
            style: TextStyle(fontSize: height * 1.6, color: Colors.black87),
          ),
          SizedBox(width: width),
          status.contains("Unpaid")
              ? Icon(Icons.cancel, size: height * 2, color: Colors.red)
              : Icon(Icons.check_circle, size: height * 2, color: Colors.green),
        ],
      ),
    );
  }

  Widget orderStatusBar(String status) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ElevatedButton(
            onPressed: () {},
            child: Text("All"),
          )),
          Expanded(
              child: ElevatedButton(
            onPressed: () {},
            child: Text("Paid"),
          )),
          Expanded(
              child: ElevatedButton(
            onPressed: () {},
            child: Text("Unpaid"),
          )),
          Expanded(
              child: ElevatedButton(
            onPressed: () {},
            child: Text("Confirmed"),
          )),
          Expanded(
              child: ElevatedButton(
            onPressed: () {},
            child: Text("Delivered"),
          )),
        ],
      ),
    );
  }

  Widget orderStatusWidget(String status) {
    return Container(
      width: width * 55,
      height: height * 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined, size: height * 2),
          SizedBox(width: width),
          Text(
            "Order Status- " + status,
            style: TextStyle(fontSize: height * 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget shimerList() {
    return Expanded(
      child: ListView.builder(
          itemCount: 10,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: height / 2),
              child: AppShimer(
                width: width * 90,
                height: height * 15,
              ))),
    );
  }

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
