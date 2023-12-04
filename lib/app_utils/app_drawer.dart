// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/category_response.dart';
import 'package:monarch_mart/app_models/drawer_item_model.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  late AppScreen screen;
  late BuildContext context;

  List helpOptions = [
    "My Account",
    "Privacy Policy",
    "Return Policy",
    "Terms",
    "Logout"
  ];
  late AppProvider provider;
  late AppProvider appprovider;

  logout() {
    appprovider.deleteSaveData();
    Navigator.pushNamedAndRemoveUntil(context, AppRoute.home, (route) => false);
    appprovider.bottomNavigation(0);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context, listen: false);
    screen = AppScreen(context);
    this.context = context;
    return Container(
      width: screen.width * 65,
      height: double.infinity,
      color: AppColor.white,
      child: ListView(
        padding: EdgeInsets.only(
            left: screen.width * 5,
            right: screen.width * 5,
            top: screen.statusbar + screen.height * 2),
        children: [
          topWidget(),
          SizedBox(height: screen.height * 4),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: helpOptions.length,
            itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: screen.height),
                child: helpsettingsView(index, helpOptions[index])),
          ),
        ],
      ),
    );
  }

  Widget topWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (provider.accessToken == null) {
              Navigator.pushNamed(context, AppRoute.profile);
            }
          },
          child: Container(
            width: screen.width * 42,
            height: screen.height * 5,
            decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(screen.height)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: screen.width * 2),
                  child: Icon(
                    Icons.account_circle,
                    color: AppColor.white,
                    size: screen.height * 4,
                  ),
                ),
                Text(
                  provider.userName ?? "Hello Sign in",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColor.white, fontSize: screen.height * 2),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: screen.width * 10,
            height: screen.height * 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screen.height / 2),
                border: Border.all(
                    color: AppColor.primary, width: screen.width / 5)),
            child: Icon(
              Icons.clear,
              color: AppColor.primary,
            ),
          ),
        )
      ],
    );
  }

  Widget header(String title) {
    return Text(
      title,
      style: TextStyle(
          color: AppColor.black,
          fontSize: screen.height * 3,
          fontWeight: FontWeight.bold),
    );
  }

  Widget helpsettingsView(int index, String title) {
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoute.profileEdit);
            break;
          case 1:
            Navigator.pushNamed(context, AppRoute.policy,
                arguments: ScreenArguments(data: {
                  "type": "privacypolicy",
                  "title": "Privacy Policy"
                }));
            break;
          case 2:
            Navigator.pushNamed(context, AppRoute.policy,
                arguments: ScreenArguments(
                    data: {"type": "returnpolicy", "title": "Return Policy"}));
            break;
          case 3:
            Navigator.pushNamed(context, AppRoute.policy,
                arguments:
                    ScreenArguments(data: {"type": "terms", "title": "Terms"}));
            break;
          default:
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screen.height)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screen.height),
                    child: Container(
                      width: screen.width * 80,
                      height: screen.height * 25,
                      padding: EdgeInsets.symmetric(
                          horizontal: screen.width * 5,
                          vertical: screen.height * 3),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: screen.height * 3,
                            ),
                          ),
                          Text(
                            "Do you really want to logout?",
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: screen.height * 2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: AppColor.primary,
                                    fixedSize: Size(
                                        screen.width * 20, screen.height * 5)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  logout();
                                },
                                child: Text("YES"),
                              ),
                              SizedBox(width: screen.width * 2),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColor.primary),
                                    fixedSize: Size(
                                        screen.width * 20, screen.height * 5)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
            break;
        }
      },
      child: Container(
        width: screen.width * 55,
        height: screen.height * 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.lightBlack,
                fontSize: screen.height * 2,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: screen.width * 10,
                height: screen.height * 5,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.lightBlack,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
