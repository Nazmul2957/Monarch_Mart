// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatelessWidget {
  late AppScreen appScreen;

  @override
  Widget build(BuildContext context) {
    appScreen = AppScreen(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark));
    nextActivity(context);
    return Scaffold(
        backgroundColor: AppColor.white,
        body: Platform.isAndroid ? androidSplash() : iosSplash());
  }

  Widget androidSplash() {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  child: Image(
                    image: AssetImage(AppImage.whiteLogo),
                    width: appScreen.width * 50,
                    height: appScreen.width * 50,
                    color: AppColor.primary,
                  ),
                ),
                Container(
                  height: appScreen.height * 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppString.build_version,
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontSize: appScreen.height * 2,
                        ),
                      ),
                      Text(
                        "v" + snapshot.data!.version,
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontSize: appScreen.height * 2,
                        ),
                      ),
                      SizedBox(height: appScreen.height * 5),
                      Image(
                        image: AssetImage(AppImage.homeIndicator),
                        width: appScreen.width * 50,
                        height: appScreen.height * 2,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Widget iosSplash() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.center,
          height: double.infinity,
          child: Image(
            image: AssetImage(AppImage.whiteLogo),
            width: appScreen.width * 50,
            height: appScreen.width * 50,
            color: AppColor.primary,
          ),
        ),
        Container(
          height: appScreen.height * 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppString.build_version,
                style: TextStyle(
                  color: AppColor.secondary,
                  fontSize: appScreen.height * 2,
                ),
              ),
              Text(
                "v" + " 3.0.0",
                style: TextStyle(
                  color: AppColor.secondary,
                  fontSize: appScreen.height * 2,
                ),
              ),
              SizedBox(height: appScreen.height * 5),
              Image(
                image: AssetImage(AppImage.homeIndicator),
                width: appScreen.width * 50,
                height: appScreen.height * 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void nextActivity(BuildContext context) async {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoute.home);
    });

    if (Platform.isAndroid || Platform.isIOS) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, AppRoute.home);
      });
      // AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      // var status =
      //     await NewVersion(androidId: "com.monarchmart").getVersionStatus();

      // if (status != null) {
      //   if (status.localVersion != status.storeVersion) {
      //     androidUpdateDialog(context, status.storeVersion, info);
      //   }
      // }
    } else {
      //for ios
    }
  }

//   void androidUpdateDialog(
//       BuildContext context, String storeVersion, AppUpdateInfo info) {
//     showCupertinoDialog(
//         context: context,
//         builder: (context) => Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.r)),
//               backgroundColor: AppColor.white,
//               child: Container(
//                 width: 350.w,
//                 height: 250.h,
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.r),
//                     color: AppColor.white),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Image(
//                       image: AssetImage(AppImage.splashLogo),
//                       width: 50.w,
//                       height: 50.h,
//                       color: AppColor.primary,
//                     ),
//                     Container(
//                       child: Text(
//                         "A new version is available on the playstore please update otherwise new features will not work on this older app",
//                         textAlign: TextAlign.justify,
//                         style: GoogleFonts.poppins(
//                           fontSize: 16.sp,
//                           color: AppColor.black,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             fixedSize: Size(300.w, 50.h),
//                             primary: Colors.green),
//                         onPressed: () {
//                           SystemNavigator.pop();
//                           var newversion = NewVersion(
//                               forceAppVersion: storeVersion,
//                               androidId: "com.monarchmart");

//                           newversion.launchAppStore(
//                               "https://play.google.com/store/apps/details?id=com.monarchmart");
//                         },
//                         child: Text(
//                           "Update",
//                           style: GoogleFonts.poppins(fontSize: 16.sp),
//                         )),
//                   ],
//                 ),
//               ),
//             ));
//   }
}
