// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_drawer.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_statusbar.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/home/home.dart';
import 'package:monarch_mart/profile/profile_provider.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';

import '../app_utils/customWidget.dart';

class Profile extends StatelessWidget {
  late AppScreen screen;
  late BuildContext context;
  var list = [
    {
      "dp": Icons.person,
      "title": "My Account",
      "subtitle": "Make changes to your account"
    },
    {
      "dp": Icons.history,
      "title": "Order History",
      "subtitle": "Take a look at your Orders"
    },
    {
      "dp": Icons.location_on,
      "title": "Shipping Address",
      "subtitle": "Change or add your address"
    },
    // {
    //   "dp": Icons.payment,
    //   "title": "Payment Info",
    //   "subtitle": "Change or add your payment"
    // },
    {
      "dp": Icons.logout,
      "title": "Logout",
      "subtitle": "Logout from your account"
    },
  ];

  var settingsOption = [
    {"dp": Icons.policy, "title": "Privacy Policy", "subtitle": ""},
    {"dp": Icons.handshake, "title": "Return Policy", "subtitle": ""},
    {"dp": Icons.headset_mic_outlined, "title": "Terms", "subtitle": ""},
  ];

  late ProfileProvider provider;
  late AppProvider appprovider;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  logout() {
    appprovider.deleteSaveData();
    Navigator.pushNamedAndRemoveUntil(context, AppRoute.home, (route) => false);
    appprovider.bottomNavigation(0);
  }

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    this.context = context;
    appprovider = Provider.of<AppProvider>(context, listen: false);
    provider = Provider.of<ProfileProvider>(context, listen: false);

    provider.init(context);
    Statusbar.darkIcon();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.white,
      appBar: Myappbar(context).appbar(
          isFromHome: false,
          title: "Profile",
          ontap: () {
            scaffoldKey.currentState?.openDrawer();
          }),
      drawer: AppDrawer(),
      body: SizedBox(
          width: double.infinity,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
            children: [
              topwidget(),
              SizedBox(height: screen.height * 2),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: screen.height / 2),
                    child: singleView(index, list[index])),
              ),
              SizedBox(height: screen.height),
              header(AppString.more_settings),
              SizedBox(height: screen.height),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: settingsOption.length,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: screen.height / 2),
                    child: singleView(index + 5, settingsOption[index])),
              ),
            ],
          )),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }

  Widget topwidget() {
    return Padding(
      padding: EdgeInsets.only(top: screen.height * 3),
      child: buildCustomDecoration(
        width: screen.width * 90,
        padding: EdgeInsets.only(
            top: screen.height * 1.5,
            bottom: screen.height * 1.5,
            left: screen.width * 3,
            right: screen.width * 3),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(screen.height),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            dp(),
            nameEmail(),
            edit(),
          ],
        ),
      ),
    );
  }

  Widget dp() {
    return Consumer<ProfileProvider>(
        builder: (context, provider, child) => buildCustomDecoration(
              width: screen.width * 15,
              height: screen.width * 15,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: AppColor.white),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screen.width * 7.5),
                child: CachedImage(
                  imageUrl: provider.imageurl.toString(),
                  placeHolder: AppImage.profilePlaceholder,
                  boxFit: BoxFit.fill,
                ),
              ),
            ));
  }

  Widget nameEmail() {
    return Consumer<ProfileProvider>(
        builder: (context, provider, child) => SizedBox(
              width: screen.width * 47,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.userName.toString(),
                    style: TextStyle(
                        color: AppColor.white,
                        fontSize: screen.height * 2.5,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    provider.email.toString(),
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: screen.height * 1.8,
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget edit() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.profileEdit);
      },
      child: Container(
        width: screen.width * 15,
        height: screen.width * 15,
        alignment: Alignment.center,
        child: Icon(
          Icons.edit,
          color: AppColor.white,
          size: screen.height * 4,
        ),
      ),
    );
  }

  Widget singleView(int index, Map<String, Object> option) {
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, AppRoute.profileEdit);
            break;
          case 1:
            Navigator.pushNamed(context, AppRoute.order);
            break;
          case 2:
            Navigator.pushNamed(context, AppRoute.address);
            break;
            // case 3:
            //   Navigator.pushNamed(context, AppRoute.paymentInfo);

            break;
          case 5:
            Navigator.pushNamed(context, AppRoute.policy,
                arguments: ScreenArguments(data: {
                  "type": "privacypolicy",
                  "title": "Privacy Policy"
                }));
            break;
          case 6:
            Navigator.pushNamed(context, AppRoute.policy,
                arguments: ScreenArguments(
                    data: {"type": "returnpolicy", "title": "Return Policy"}));
            break;
          case 7:
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
            SizedBox(
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
            SizedBox(
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

  Widget header(String title) {
    return Text(
      title,
      style: TextStyle(
          color: AppColor.black,
          fontSize: screen.height * 3,
          fontWeight: FontWeight.bold),
    );
  }
}
