import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../order_details_provider.dart';

// ignore: must_be_immutable
class TimeLineStatus extends StatelessWidget {
  OrderDetailsProvider presenter;
  double width, height;
  TimeLineStatus(
      {required this.presenter, required this.width, required this.height});
  List steps = [
    'pending',
    'confirmed',
    'picked_up',
    'on_the_way',
    "delivered",
    "cancelled"
  ];
  List statusString = [
    "Pending",
    "Confirmed",
    "Picked Up",
    "On The Way",
    "Delivered",
  ];
  late int stepIndex;
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsProvider>(
      builder: (context, ob, child) {
        if (ob.response != null) {
          stepIndex = steps.indexOf(ob.response!.data![0].deliveryStatus);

          return Container(
            width: width * 90,
            height: height * 12,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  timeLinetiles(0, statusString[0], Icons.list_alt,
                      stepIndex == 5 ? Colors.redAccent : Colors.red),
                  timeLinetiles(1, statusString[1], Icons.thumb_up_sharp,
                      stepIndex == 5 ? Colors.red : Colors.blue),
                  timeLinetiles(2, statusString[2], Icons.drive_eta_outlined,
                      stepIndex == 5 ? Colors.red : Colors.amber),
                  timeLinetiles(
                      3,
                      statusString[3],
                      Icons.local_shipping_outlined,
                      stepIndex == 5 ? Colors.red : Colors.purple),
                  timeLinetiles(4, statusString[4], Icons.done_all,
                      stepIndex == 5 ? Colors.red : Colors.cyan),
                ],
              ),
            ),
          );
        } else {
          return timeLineShimer();
        }
      },
    );
  }

  Widget timeLinetiles(
      int compareValue, String title, IconData icons, Color color) {
    return Container(
      width: width * 22.5,
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.end,
        isFirst: title.contains("Pending"),
        isLast: title.contains("Deliverd"),
        startChild: iconTitles(title, icons, color),
        indicatorStyle: IndicatorStyle(
          color: stepIndex >= compareValue
              ? stepIndex == 5
                  ? Colors.grey.withOpacity(0.8)
                  : Colors.green
              : AppColor.secondary,
          height: height * 3,
          iconStyle: stepIndex >= compareValue
              ? IconStyle(
                  color: stepIndex == 5 ? Colors.red : Colors.white,
                  iconData:
                      stepIndex == 5 ? Icons.cancel_outlined : Icons.check,
                  fontSize: height * 2)
              : null,
        ),
        beforeLineStyle: stepIndex >= compareValue
            ? LineStyle(
                color: stepIndex == 5 ? Colors.red : Colors.green,
                thickness: height * 0.8,
              )
            : LineStyle(
                color: AppColor.secondary,
                thickness: height * 0.8,
              ),
        afterLineStyle: stepIndex > compareValue + 1
            ? LineStyle(
                color: stepIndex == 5 ? Colors.red : Colors.green,
                thickness: height * 0.8,
              )
            : LineStyle(
                color: stepIndex == 5 ? Colors.transparent : AppColor.secondary,
                thickness: height * 0.8,
              ),
      ),
    );
  }

  Widget iconTitles(String titles, IconData icons, Color color) {
    return Column(
      children: [
        Container(
          width: width * 10,
          height: width * 10,
          padding: EdgeInsets.all(width),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: width / 2),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Icon(icons, size: height * 3, color: color),
        ),
        Padding(
            padding: EdgeInsets.only(top: height / 2),
            child: Text(titles,
                style:
                    TextStyle(color: Colors.black87, fontSize: height * 1.5)))
      ],
    );
  }

  Widget timeLineShimer() {
    return Container(
      width: width * 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < 4; i++)
                  AppShimer(height: width * 13, width: width * 13)
              ],
            ),
          ),
          SizedBox(height: height * 2),
          AppShimer(
            width: width * 80,
            height: height * 3,
          )
        ],
      ),
    );
  }
}
