import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/order_details_response.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:provider/provider.dart';

import '../order_details_provider.dart';

// ignore: must_be_immutable
class OrderInfo extends StatelessWidget {
  OrderDetailsProvider presenter;
  double width, height;
  OrderInfo(
      {required this.presenter, required this.width, required this.height});

  late int stepIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsProvider>(builder: (context, ob, child) {
      if (ob.response != null) {
        return Container(
          padding: EdgeInsets.all(width * 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height),
              border: Border.all(width: width / 6, color: AppColor.yellow)),
          child: Column(
            children: [
              Row(
                children: [
                  shipmentSingleOptions(
                    "Order Code : ",
                    ob.response!.data![0].code.toString(),
                  ),
                ],
              ),
              SizedBox(height: height),
              Row(
                children: [
                  shipmentSingleOptions(
                    "Order Date : ",
                    ob.response!.data![0].date.toString(),
                  ),
                ],
              ),
              SizedBox(height: height),
              Row(
                children: [
                  shipmentSingleOptions(
                    "Payment Method : ",
                    ob.response!.data![0].paymentType.toString(),
                  )
                ],
              ),
              SizedBox(height: height),
              Row(
                children: [
                  shipmentSingleOptions(
                    "Payment Status : ",
                    ob.response!.data![0].paymentStatusString.toString(),
                  ),
                ],
              ),
              SizedBox(height: height),
              shippingAddressTotalAmount(ob.response),
            ],
          ),
        );
      } else {
        return AppShimer(
          width: width * 90,
          height: height * 38,
        );
      }
    });
  }

  Widget shippingAddressTotalAmount(OrderDetailsResponse? response) {
    return Container(
      child: Row(
        children: [
          Container(
            width: width * 85.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: height / 2),
                //   child: Text(
                //     "Shipping Address",
                //     style: TextStyle(
                //         fontSize: height * 1.7,
                //         color: AppColor.secondary,
                //         fontWeight: FontWeight.w600),
                //   ),
                // ),

                shipmentSingleOptions("Shipping Address : ",
                    response?.data?[0].shippingAddress?.address ?? "N/A"),
                shipmentSingleOptions("City: ",
                    response?.data?[0].shippingAddress?.city ?? "N/A"),
                shipmentSingleOptions("Country: ",
                    response?.data?[0].shippingAddress?.country ?? "N/A"),
                shipmentSingleOptions("Phone: ",
                    response?.data?[0].shippingAddress?.phone ?? "N/A"),
                shipmentSingleOptions("Postal Code: ",
                    response?.data?[0].shippingAddress?.postalCode ?? "N/A"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shipmentSingleOptions(String heading, String data) {
    return Container(
      padding: EdgeInsets.all(6),
      color: Color.fromARGB(255, 240, 239, 239),
      width: width * 85,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height / 6),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: heading,
                style: TextStyle(
                  color: AppColor.secondary,
                  fontSize: height * 2.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                  text: data,
                  style: TextStyle(
                      letterSpacing: width / 8,
                      wordSpacing: width / 8,
                      fontSize: height * 2.1,
                      color: AppColor.secondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonWidget(String title, String data, bool isInLeft) {
    return Container(
      color: AppColor.secondary,
      width: width * 42.5,
      child: Column(
        crossAxisAlignment:
            isInLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: height / 2),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: height * 1.7,
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w600),
            ),
          ),
          title.contains("Payment Status")
              ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Text(
                        data,
                        style: TextStyle(
                            fontSize: height * 1.6,
                            color: AppColor.secondary,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      width: width * 5,
                      height: width * 5,
                      child: data.contains("Unpaid")
                          ? Icon(Icons.cancel,
                              size: height * 2, color: Colors.red)
                          : Icon(Icons.check_circle,
                              size: height * 2, color: Colors.green),
                    )
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: Text(
                    data,
                    style: TextStyle(
                        fontSize: height * 1.6,
                        color: title.contains("Code")
                            ? Colors.black
                            : AppColor.secondary,
                        fontWeight: title.contains("Code")
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ),
        ],
      ),
    );
  }
}
