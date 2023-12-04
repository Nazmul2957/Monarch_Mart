// ignore_for_file: must_be_immutable

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../product_details_provider.dart';

class Description extends StatelessWidget {
  late AppScreen screen;
  ProductDetailsProvider provider;

  Description({required this.provider});

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.response != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screen.height),
              Header(title: "Description", color: AppColor.primary),
              SizedBox(height: screen.height),
              provider.productDescription != null
                  // ? expandableDescription()
                  ? Html(data: provider.productDescription)
                  : Text("No Description Available"),
            ],
          );
        } else {
          return AppShimer(
            width: screen.width * 90,
            height: screen.height * 10,
          );
        }
      },
    );
  }

  Widget expandableDescription() {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Container(
                height: screen.height * 10,
                child: Html(data: provider.productDescription)),
            expanded: Html(data: provider.productDescription),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Builder(
                builder: (context) {
                  ExpandableController? controller =
                      ExpandableController.of(context);

                  return InkWell(
                    child: Text(
                      !controller!.expanded ? "View More" : "Show Less",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: screen.height * 1.4),
                    ),
                    onTap: () {
                      controller.toggle();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
