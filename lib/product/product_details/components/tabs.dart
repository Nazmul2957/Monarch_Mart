// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/tab_buttons.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';

import '../product_details_provider.dart';
import 'description.dart';

class Tabs extends StatelessWidget {
  ProductDetailsProvider provider;

  Tabs({required this.provider});

  late AppScreen screen;
  var settingsOption = [
    {"dp": Icons.policy, "title": "Privacy Policy", "subtitle": ""},
    {"dp": Icons.policy, "title": "Return Policy", "subtitle": ""},
    {"dp": Icons.headset_mic_outlined, "title": "Terms", "subtitle": ""},
  ];

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    this.context = context;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screen.width * 2.5),
      child: Column(
        children: [
          Container(
            child: TabButton(onClck: (int i) {
              if (i == 1) {
                if (Provider.of<AppProvider>(context, listen: false)
                        .accessToken !=
                    null) {
                  Navigator.pushNamed(context, AppRoute.reviewtwo,
                      arguments: ScreenArguments(data: {
                        "productId": provider.response!.data![0].id.toString()
                      }));
                } else {
                  Navigator.pushNamed(context, AppRoute.login);
                }
              } else {
                provider.currentWidget(i);
              }
            }),
          ),
          SizedBox(height: screen.height),
          Consumer<ProductDetailsProvider>(
            builder: (context, ob, child) {
              if (ob.currentWidgetIndex == 0) {
                return Description(provider: provider);
              } else {
                return Container(
                  width: screen.width * 95,
                  padding: EdgeInsets.only(top: screen.height * 2),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: settingsOption.length,
                    itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: screen.height / 2),
                        child: singleView(index, settingsOption[index])),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget singleView(int index, Map<String, Object> option) {
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, AppRoute.webview,
                arguments: ScreenArguments(data: {
                  "url": AppUrl.raw_url + "/privacypolicy",
                  "title": "Privacy Policy"
                }));
            break;
          case 1:
            Navigator.pushNamed(context, AppRoute.webview,
                arguments: ScreenArguments(data: {
                  "url": AppUrl.raw_url + "/returnpolicy",
                  "title": "Return Policy"
                }));
            break;

          default:
            Navigator.pushNamed(context, AppRoute.webview,
                arguments: ScreenArguments(data: {
                  "url": AppUrl.raw_url + "/terms",
                  "title": "Terms"
                }));
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: screen.height),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screen.width * 15,
              height: screen.width * 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary.withOpacity(0.1)),
              child: Icon(
                option["dp"] as IconData,
                color: AppColor.primary,
                size: screen.height * 4,
              ),
            ),
            Container(
              width: screen.width * 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option["title"].toString(),
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: screen.height * 2.2,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    option["subtitle"].toString(),
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: screen.height * 1.7,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screen.width * 10,
              height: screen.height * 5,
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColor.lightBlack,
              ),
            )
          ],
        ),
      ),
    );
  }
}
