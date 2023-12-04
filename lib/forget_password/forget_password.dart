import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/forget_password/forget_password_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatelessWidget {
  late ForgetPasswordProvider presenter;
  late double width, height, statusbar;
  String phone = "";

  var emailController = new TextEditingController();
  var phoneController = new TextEditingController();

  initializeProperty(context) {
    presenter = Provider.of<ForgetPasswordProvider>(context, listen: false);
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
                title: "Forget Password?", width: width, height: height),
            SizedBox(height: height * 5),
            Container(
              width: width * 70,
              child: Consumer<ForgetPasswordProvider>(
                builder: (context, ob, child) {
                  if (ob.method.compareTo("email") == 0) {
                    return editTextEmailBlock(
                        "Email", emailController, "a Phone");
                  } else {
                    return editTextPhoneBlock(
                        "Phone", phoneController, " an Email");
                  }
                },
              ),
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
                if (presenter.method.compareTo("email") == 0) {
                  presenter.validateAndPost(emailOrPhone: emailController.text);
                } else {
                  presenter.validateAndPost(emailOrPhone: phoneController.text);
                }
              },
              child: Text(
                "Send Codes",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editTextEmailBlock(String title, controller, String buttonText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.secondary, width: width / 5)),
          child: EditText(
            hints: "johndoe@gmail.com",
            isObscure: false,
            width: width * 90,
            height: height * 6,
            controller: controller,
          ),
        ),
        GestureDetector(
          onTap: () {
            presenter.setMethod("phone");
          },
          child: Text(
            "or, Send code via " + buttonText,
            style: TextStyle(
                color: AppColor.secondary,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  Widget editTextPhoneBlock(String title, controller, String buttonText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.secondary, width: width / 5)),
          child: EditText(
            hints: "Enter Your Number",
            isObscure: false,
            width: width * 90,
            height: height * 6,
            controller: controller,
          ),
        ),
        GestureDetector(
          onTap: () {
            presenter.setMethod("email");
          },
          child: Text(
            "or,  Send code via" + buttonText,
            style: TextStyle(
                color: AppColor.secondary,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
