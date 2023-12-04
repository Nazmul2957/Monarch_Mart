import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_statusbar.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/login/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_utils/customWidget.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AppScreen screen;
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  late LoginProvider provider;

  @override
  Widget build(BuildContext context) {
    Statusbar.lightIcon();
    screen = AppScreen(context);
    provider = Provider.of<LoginProvider>(context, listen: false);
    if (provider.isnotInitialized) {
      provider.init(context: context);
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, // this is new
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.white,
          shadowColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: AppColor.primary)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
              child: Column(
                children: [
                  logo(),
                  headingBlock(),
                  SizedBox(height: 24.h),
                  PhoneField(controller: phoneController),
                  SizedBox(height: 24.h),
                  // buildCustomButton(child:Text(AppString.login) )
                  Obx(
                    () => Button(
                        showLoader: provider.loginController.loginLoader.value,
                        width: screen.width * 90,
                        height: screen.height * 6,
                        onTap: () {
                          if (!provider.loginController.loginLoader.value) {
                            provider.validateAndLogin(
                                phoneEmail: phoneController.text);
                          }
                        },
                        buttonColor: AppColor.primary,
                        fontColor: AppColor.white,
                        title: AppString.login),
                  ),
                  Padding(
                      // this is new
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logoSet() {
    return Container(
      alignment: Alignment.center,
      width: screen.width * 60,
      height: screen.height * 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(AppImage.facebookIcon),
            width: screen.width * 15,
          ),
          Image(
            image: AssetImage(AppImage.googleIcon),
            width: screen.width * 15,
          ),
          Image(
            image: AssetImage(AppImage.messengerIcon),
            width: screen.width * 15,
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Container(
        width: 147.w,
        height: 125.h,
        child: Image(
          image: AssetImage(AppImage.orangeLogo),
        ),
      ),
    );
  }

  Widget headingBlock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 83.h),
          child: Container(
            height: 36.h,
            alignment: Alignment.center,
            child: Text(AppString.login,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: AppColor.primary)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 48.h),
          child: Container(
            height: 24.h,
            alignment: Alignment.center,
            child: Text("Enter Your Mobile Number",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: AppColor.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
          ),
        ),
      ],
    );
  }

  void saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(AppConstant.LOGGED_IN, true);
  }
}
