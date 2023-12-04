// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/checkout_model.dart';
import 'package:monarch_mart/app_models/payment_method_response.dart';
import 'package:monarch_mart/app_network/MyClient.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_components/app_constant.dart';
import 'nogod_repay.dart';

class RepayOptions extends StatefulWidget {
  String? orderId;
  String? userId;

  RepayOptions({required this.orderId});

  @override
  State<RepayOptions> createState() => _RepayOptionsState();
}

class _RepayOptionsState extends State<RepayOptions> {
  String? selectedPaymentMethod = "", selectedPaymentMethodKey = "";
  late double width, height;
  List<CheckoutModel> checkoutModel = [];
  List<PaymentMethodResponse>? paymentOptions = [];

  @override
  void initState() {
    super.initState();
    getUserinfo().then((value) => getPaymentMethodList(value[1]));
  }

  Future getUserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));
    return holder;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;
    return Container(
        width: 80 * width,
        height: 60 * height,
        padding:
            EdgeInsets.symmetric(horizontal: width * 5, vertical: height * 2),
        child: checkoutModel.isEmpty
            ? shimerList()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Payment Options",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: 40 * height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: width * 5),
                      itemCount: checkoutModel.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 2),
                          child: paymentMethodCard(checkoutModel[index], index),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 2),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppColor.primary,
                          fixedSize: Size(200.w, 60.h)),
                      onPressed: () {
                        Navigator.pop(context, selectedPaymentMethod);
                      },
                      child: Text(
                        "Pay Now",
                        style: GoogleFonts.poppins(fontSize: 15.sp),
                      ))
                ],
              ));
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

  Widget shimerList() {
    return ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: width * 5),
        itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: height),
            child: AppShimer(
                width: width * 90, height: height * 15, borderRadius: height)));
  }

  Widget paymentMethodCard(CheckoutModel checkoutModel, int index) {
    bool isSelected = selectedPaymentMethod
            ?.compareTo(checkoutModel.paymentType.toString()) ==
        0;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = checkoutModel.paymentType.toString();
          selectedPaymentMethodKey = checkoutModel.paymentTypeKey;
        });
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
                    imageUrl: checkoutModel.image.toString(),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height * 10,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      checkoutModel.title.toString(),
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

  void selectMethod(int index) {
    selectedPaymentMethod = checkoutModel[index].paymentType.toString();
    selectedPaymentMethodKey = checkoutModel[index].paymentTypeKey.toString();
  }

  Future getPaymentMethodList(String userId) async {
    try {
      var caller = await MyClient.get(endpoint: "/payment-types/$userId");
      paymentOptions = (jsonDecode(caller.body) as List)
          .map((ob) => PaymentMethodResponse.fromJson(ob))
          .toList();

      paymentOptions?.forEach((ob) {
        print(ob.paymentType);
        if (ob.paymentType != "cash_payment") {
          checkoutModel.add(CheckoutModel(
              title: ob.title,
              image: ob.image,
              paymentType: ob.paymentType,
              paymentTypeKey: ob.paymentTypeKey));
        }
      });

      setState(() {
        selectedPaymentMethod = checkoutModel[0].paymentType.toString();
        selectedPaymentMethodKey = checkoutModel[0].paymentTypeKey.toString();
      });
    } catch (e) {}
  }
}
