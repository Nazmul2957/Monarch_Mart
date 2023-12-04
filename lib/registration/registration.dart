import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_statusbar.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/background_widget.dart';
import 'package:monarch_mart/registration/registration_provider.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late AppScreen screen;
  var mailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    var provider = Provider.of<RegistrationProvider>(context, listen: false);
    provider.init(context: context);
    Statusbar.lightIcon();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoute.login);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: AppColor.white,
        //   shadowColor: Colors.transparent,
        //   leading: IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(Icons.arrow_back, color: AppColor.primary)),
        // ),
        body: Background(
            height: screen.height * 75,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: screen.width * 5),
              children: [
                logo(),
                headingBlock(),
                SizedBox(height: screen.height * 4),
                EditText(
                    controller: nameController,
                    width: screen.width * 90,
                    height: screen.height * 6,
                    hints: AppString.name_hints),
                SizedBox(height: screen.height * 2),
                EditText(
                    controller: mailController,
                    width: screen.width * 90,
                    height: screen.height * 6,
                    hints: AppString.email_hints),
                SizedBox(height: screen.height * 2),
                EditText(
                    controller: passwordController,
                    width: screen.width * 90,
                    height: screen.height * 6,
                    isObscure: true,
                    hints: AppString.password_hints),
                SizedBox(height: screen.height * 2),
                EditText(
                    controller: confirmPass,
                    width: screen.width * 90,
                    height: screen.height * 6,
                    isObscure: true,
                    hints: AppString.confirm_your_password),
                SizedBox(height: screen.height * 5),
                Button(
                    width: screen.width * 90,
                    height: screen.height * 6,
                    onTap: () {
                      Provider.of<RegistrationProvider>(context, listen: false)
                          .validateAndRegister(
                              name: nameController.text,
                              phoneEmail: mailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPass.text);
                    },
                    buttonColor: AppColor.primary,
                    fontColor: AppColor.white,
                    title: AppString.create_account),
                SizedBox(height: screen.height * 3),

                SizedBox(height: screen.height * 4),
                //  logoSet(),
                SizedBox(height: screen.height * 2),
                Image(
                    image: AssetImage(AppImage.homeIndicator),
                    width: screen.width * 50,
                    height: screen.height * 2),
              ],
            )),
      ),
    );
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: screen.height * 8),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Center(
            child: Container(
              width: screen.width * 30,
              height: screen.width * 30,
              child: Image(
                image: AssetImage(AppImage.whiteLogo),
              ),
            ),
          ),
          Container(
            width: screen.width * 90,
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoute.login);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColor.white,
                  size: screen.height * 3,
                )),
          )
        ],
      ),
    );
  }

  Widget headingBlock() {
    return Padding(
      padding: EdgeInsets.only(top: screen.height * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppString.register,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: screen.height * 6,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(top: screen.height * 2),
            child: Text(
              AppString.create_account,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screen.height * 4,
                color: Colors.white,
              ),
            ),
          )
        ],
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
}
