import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_font.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/reset_password/reset_pass_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget {
  late double width, height, statusbar;
  late ResetPasswordProvider presenter;

  var passwordController = new TextEditingController();
  var confirmpasswordController = new TextEditingController();
  var verificationCodeController = new TextEditingController();

  initializeProperty(context) {
    presenter = Provider.of<ResetPasswordProvider>(context, listen: false);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    initializeProperty(context);
    if (!presenter.isinitialized) {
      presenter.init(context: context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width * 100,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: width * 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageTitleBlock(
                  title: "Reset Password", width: width, height: height),
              SizedBox(height: height * 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: height),
                    child: Text(
                      "Enter Varification Code",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: AppFont.Poppins, fontSize: height * 2),
                    ),
                  ),
                  Container(
                    width: width * 70,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.secondary, width: width / 5)),
                    child: EditText(
                      width: width * 70,
                      height: height * 6,
                      controller: verificationCodeController,
                      hints: "",
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: height),
                    child: Text(
                      "Enter Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: AppFont.Poppins, fontSize: height * 2),
                    ),
                  ),
                  Container(
                    width: width * 70,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.secondary, width: width / 5)),
                    child: EditText(
                      width: width * 70,
                      height: height * 6,
                      controller: passwordController,
                      isObscure: true,
                      hints: "*****",
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: height),
                    child: Text(
                      "Confirm Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: AppFont.Poppins, fontSize: height * 2),
                    ),
                  ),
                  Container(
                    width: width * 70,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.secondary, width: width / 5)),
                    child: EditText(
                      width: width * 70,
                      height: height * 6,
                      isObscure: true,
                      controller: confirmpasswordController,
                      hints: "*****",
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.5,
                  fixedSize: Size(width * 70, height * 5),
                  primary: AppColor.primary,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: height * 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  presenter.validateAndPost(
                    verificationCode: verificationCodeController.text,
                    password: passwordController.text,
                    confirmPassword: confirmpasswordController.text,
                  );
                },
                child: Text(
                  "Change Password",
                ),
              ),
            ]),
      ),
    );
  }
}
