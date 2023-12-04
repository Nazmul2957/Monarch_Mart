import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/checkout_model.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/customWidget.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:provider/provider.dart';

import '../../controllers/loader_controller.dart';
import 'checkout_provider.dart';
import 'compoents/amount_details.dart';

// ignore: must_be_immutable
class Checkout extends StatelessWidget {
  final LoaderController loaderController = Get.find();
  String ownerId;

  Checkout({required this.ownerId});

  late double width, height, statusbar;
  late BuildContext context;
  late CheckoutProvider provider;
  var couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    provider = Provider.of<CheckoutProvider>(context, listen: false);

    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;

    if (provider.isNotInitialize) {
      provider.init(context: context, ownerId: ownerId);
    }

    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: Myappbar(context).appBarCommon(title: "Checkout"),
          body: Consumer<CheckoutProvider>(builder: (context, ob, child) {
            if (ob.checkoutModel.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 5),
                itemCount: ob.checkoutModel.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: height / 2),
                    child: paymentMethodCard(ob.checkoutModel[index], index),
                  );
                },
              );
            } else {
              return shimerList();
            }
          }),
          bottomNavigationBar: ListView(
            shrinkWrap: true,
            children: [bottomOptions(), AppBottomNavigation()],
          ),
        ));
  }

  Widget paymentMethodCard(CheckoutModel checkoutModel, int index) {
    bool isSelected = provider.selectedPaymentMethod!
            .compareTo(checkoutModel.paymentType.toString()) ==
        0;
    return InkWell(
      onTap: () {
        provider.selectMethod(index);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: width * 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height),
              border: Border.all(
                width: width / 5,
                color: isSelected ? Colors.green : AppColor.primary,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 16,
                  height: width * 16,
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 2, vertical: height),
                  child: CachedImage(
                    imageUrl: provider.checkoutModel[index].image.toString(),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height * 10,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      provider.checkoutModel[index].title.toString(),
                      style: TextStyle(
                        fontSize: height * 1.8,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          isSelected
              ? Padding(
                  padding: EdgeInsets.only(top: height / 2, right: width * 1.5),
                  child: Icon(Icons.check_circle,
                      size: height * 2.5, color: Colors.green),
                )
              : Container()
        ],
      ),
    );
  }

  Widget bottomOptions() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: width * 5),
      width: width * 100,
      height: height * 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          applyCoupon(),
          totalAmountBlock(),
          confirmOrder(),
        ],
      ),
    );
  }

  Widget applyCoupon() {
    return Container(
      height: height * 5.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          border: Border.all(
            width: width / 5,
            color: AppColor.primary,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width * 59,
            height: height * 5,
            padding: EdgeInsets.only(left: width),
            child: TextFormField(
              controller: couponController,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: height * 1.8),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  hintText: "Enter Coupon",
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    top: height * 1.6,
                  )),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: AppColor.primary,
                  fixedSize: Size(width * 30, height * 5.5),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: height * 1.6,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                if (couponController.text.isNotEmpty) {
                  provider.applyCoupon(couponCode: couponController.text);
                } else {
                  Toast.createToast(
                      context: context,
                      message: "Insert Coupon Code",
                      duration: Duration(milliseconds: 1500));
                }
              },
              child: Text("Apply Coupon"))
        ],
      ),
    );
  }

  Widget totalAmountBlock() {
    return Container(
      width: width * 90,
      padding: EdgeInsets.symmetric(vertical: height, horizontal: width * 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: AppColor.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: height * 1.8,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: width * 3),
              GestureDetector(
                onTap: () {
                  if (provider.checkoutSummaryResponse != null) {
                    AmountDetails.openDialog(
                        context: context,
                        response: provider.checkoutSummaryResponse);
                  }
                },
                child: Text(
                  "see details",
                  style: TextStyle(
                      color: AppColor.white,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          Consumer<CheckoutProvider>(
            builder: (context, ob, child) => Text(
              ob.checkoutSummaryResponse == null
                  ? "...."
                  : "\u09F3 " +
                      ob.checkoutSummaryResponse!.grandTotal.toString(),
              style: TextStyle(
                fontSize: height * 1.8,
                color: AppColor.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget confirmOrder() {
    return Padding(
      padding: EdgeInsets.only(bottom: height),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: AppColor.primary,
              fixedSize: Size(width * 90, height * 5.5),
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: height * 1.8,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            if (provider.selectedPaymentMethod!.isNotEmpty) {
              if (!loaderController.confirmOrderLoader.value) {
                placeOrder();
              }
            } else {
              Toast.createToast(
                context: context,
                message: "Select a payment method first",
                duration: Duration(seconds: 2),
              );
            }
          },
          child: Obx(
            () => buildButtonTextLoader(
                btnText: "Confirm Order",
                showLoader: loaderController.confirmOrderLoader.value),
          )),
    );
  }

  Widget shimerList() {
    return ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: width * 5),
        itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: height),
            child: AppShimer(
                width: width * 90, height: height * 15, borderRadius: height)));
  }

  void placeOrder() {
    if (provider.checkoutSummaryResponse != null) {
      loaderController.confirmOrderLoader.value = true;
      // var progress = NetworkProgress();
      // progress.showProgress(context);
      switch (provider.selectedPaymentMethod) {
        case "bkash":
          provider
              .createOrder(
                  paymentMethod: provider.selectedPaymentMethod.toString())
              .then((value) {
            // progress.closeDialog();
            loaderController.confirmOrderLoader.value = false;
            Navigator.pushNamed(context, AppRoute.bkash,
                arguments: ScreenArguments(data: {
                  "ownerId": ownerId,
                  "orderId":
                      provider.createResponse!.combinedOrderId.toString(),
                  "amount": provider.checkoutSummaryResponse!.grandTotalValue
                      .toString(),
                  "methodkey": provider.selectedPaymentMethodKey,
                  "paymentType": provider.selectedPaymentMethod
                }));
          });
          break;
        case "nagad":
          provider
              .createOrder(
                  paymentMethod: provider.selectedPaymentMethod.toString())
              .then((value) {
            // progress.closeDialog();
            loaderController.confirmOrderLoader.value = false;
            Navigator.pushNamed(context, AppRoute.nagad,
                arguments: ScreenArguments(data: {
                  "ownerId": ownerId,
                  "orderId":
                      provider.createResponse!.combinedOrderId.toString(),
                  "amount": provider.checkoutSummaryResponse!.grandTotalValue
                      .toString(),
                  "methodkey": provider.selectedPaymentMethodKey,
                  "paymentType": provider.selectedPaymentMethod
                }));
          });
          break;
        case "upay":
          provider
              .createOrder(
                  paymentMethod: provider.selectedPaymentMethod.toString())
              .then((value) {
            // progress.closeDialog();
            loaderController.confirmOrderLoader.value = false;
            Navigator.pushNamed(context, AppRoute.upay,
                arguments: ScreenArguments(data: {
                  "ownerId": ownerId,
                  "orderId":
                      provider.createResponse!.combinedOrderId.toString(),
                  "amount": provider.checkoutSummaryResponse!.grandTotalValue
                      .toString(),
                  "methodkey": provider.selectedPaymentMethodKey,
                  "paymentType": provider.selectedPaymentMethod
                }));
          });
          break;
        case "sslcommerz_payment":
          provider
              .createOrder(
                  paymentMethod: provider.selectedPaymentMethod.toString())
              .then((value) {
            // progress.closeDialog();
            loaderController.confirmOrderLoader.value = false;
            print("this is the response:");
            print(provider.createResponse!.toJson());
            Navigator.pushNamed(context, AppRoute.sslCommerz,
                arguments: ScreenArguments(data: {
                  "ownerId": ownerId,
                  "orderId":
                      provider.createResponse!.combinedOrderId.toString(),
                  "amount": provider.checkoutSummaryResponse!.grandTotalValue
                      .toString(),
                  "methodkey": provider.selectedPaymentMethodKey,
                  "paymentType": provider.selectedPaymentMethod
                }));
          });
          break;
        case "ucb_bank":
          provider
              .createOrder(
                  paymentMethod: provider.selectedPaymentMethod.toString())
              .then((value) {
            // progress.closeDialog();
            loaderController.confirmOrderLoader.value = false;

            Navigator.pushNamed(context, AppRoute.ucb,
                arguments: ScreenArguments(data: {
                  "ownerId": ownerId,
                  "orderId":
                      provider.createResponse!.combinedOrderId.toString(),
                  "amount": provider.checkoutSummaryResponse!.grandTotalValue
                      .toString(),
                  "methodkey": provider.selectedPaymentMethodKey,
                  "paymentType": provider.selectedPaymentMethod
                }));
          });
          break;
        case "cash_payment":
          provider
              .createOrderFromCod(paymentMethod: provider.selectedPaymentMethod)
              .then((value) {
            loaderController.confirmOrderLoader.value = false;
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoute.profile, (route) => false);
            Navigator.pushNamed(context, AppRoute.order);
          });
          break;

        default:
          break;
      }
    }
  }
}
