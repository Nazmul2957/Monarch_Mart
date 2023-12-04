import 'package:flutter/material.dart';
import 'package:monarch_mart/orders/order_provider.dart';

import 'dropdown_bar.dart';

class Orderdropdown {
  static void create(
      {required BuildContext context,
      required OrderProvider presenter,
      required double dx,
      required double dy,
      required List<Options> list,
      required isPayment}) {
    double statusbar = MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width / 100;
    double height = (MediaQuery.of(context).size.height - statusbar) / 100;
    showGeneralDialog(
        barrierColor: Colors.transparent,
        transitionDuration: Duration(milliseconds: 100),
        transitionBuilder: (_, Animation<double> animation, __, Widget child) {
          return new SlideTransition(
            child: child,
            position: new Tween<Offset>(
              begin: Offset(isPayment ? -1.0 : 1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
          );
        },
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return DropdownWindows(
            width: width,
            height: height,
            context: context,
            presenter: presenter,
            isPayment: isPayment,
            list: list,
            dx: dx,
            dy: dy,
          );
        });
  }
}

// ignore: must_be_immutable
class DropdownWindows extends StatelessWidget {
  double width, height, dx, dy;
  BuildContext context;
  OrderProvider presenter;
  List<Options> list;
  bool isPayment;
  DropdownWindows({
    required this.width,
    required this.height,
    required this.context,
    required this.presenter,
    required this.list,
    required this.isPayment,
    required this.dx,
    required this.dy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: dy + height * 4,
              left: dx,
              child: GestureDetector(
                onTap: () {},
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      width: width * 35,
                      height: height * 4.2 * list.length,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: width / 10,
                          blurRadius: height / 4,
                          offset: Offset(width / 5, width / 2),
                        ),
                      ]),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: list.length,
                          itemBuilder: (context, index) => item(index)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            presenter.setDropdowns(isPayment, list[index]);
            Navigator.pop(context);
          },
          child: Container(
            height: height * 4,
            width: width * 32.4,
            padding: EdgeInsets.only(right: width * 2),
            alignment: Alignment.center,
            child: Text(
              list[index].name,
              style: TextStyle(
                fontSize: height * 1.6,
              ),
            ),
          ),
        ),
        Divider(
          height: height / 10,
          color: Colors.grey,
        ),
      ],
    );
  }
}
