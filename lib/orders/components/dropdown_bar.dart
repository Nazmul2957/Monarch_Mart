import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/orders/order_provider.dart';
import 'package:provider/provider.dart';

import 'order_dropdown.dart';

// ignore: must_be_immutable
class Dropdownbar extends StatelessWidget {
  OrderProvider presenter;
  double width, height;
  Dropdownbar(
      {required this.presenter, required this.height, required this.width});

  late GlobalKey mykey = new GlobalKey();
  late GlobalKey mykey1 = new GlobalKey();
  late Offset offset;
  late BuildContext context;
  Offset getOffset(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      width: width * 90,
      height: height * 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          paymentOptionBox(),
          delivaryOptionBox(),
        ],
      ),
    );
  }

  Widget paymentOptionBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          key: mykey,
          onTap: () {
            offset = getOffset(mykey);
            Orderdropdown.create(
                context: context,
                presenter: presenter,
                dx: offset.dx,
                dy: offset.dy,
                list: Options.getPaymentOptions(),
                isPayment: true);
          },
          child: Container(
            width: width * 35,
            height: height * 4,
            decoration: BoxDecoration(
              border: Border.all(
                width: width / 10,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
            child: Consumer<OrderProvider>(
              builder: (context, ob, child) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ob.selecetedPayment!.name.toString(),
                    style: TextStyle(
                        fontSize: height * 1.6, color: Colors.black87),
                  ),
                  SizedBox(width: width),
                  Icon(
                    Icons.expand_more,
                    size: height * 2,
                    color: Colors.black87,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget delivaryOptionBox() {
    return Row(
      children: [
        InkWell(
          key: mykey1,
          onTap: () {
            offset = getOffset(mykey1);
            Orderdropdown.create(
                context: context,
                presenter: presenter,
                dx: offset.dx,
                dy: offset.dy,
                list: Options.getDelivaryOptions(),
                isPayment: false);
          },
          child: Container(
              width: width * 35,
              height: height * 4,
              decoration: BoxDecoration(
                border: Border.all(
                  width: width / 10,
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
              child: Consumer<OrderProvider>(
                builder: (context, ob, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ob.selectedDelivary!.name.toString(),
                      style: TextStyle(
                          fontSize: height * 1.6, color: Colors.black87),
                    ),
                    SizedBox(width: width),
                    Icon(
                      Icons.expand_more,
                      size: height * 2,
                      color: Colors.black87,
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class Options {
  String optionKey;
  String name;

  Options(this.optionKey, this.name);

  static List<Options> getPaymentOptions() {
    return <Options>[
      Options("", "All"),
      Options("paid", "Paid"),
      Options("unpaid", "Unpaid"),
    ];
  }

  static List<Options> getDelivaryOptions() {
    return <Options>[
      Options("", "All"),
      Options("confirmed", "Confirmed"),
      Options("on_delivery", "On Delivery"),
      Options("delivered", "Delivered"),
    ];
  }
}
