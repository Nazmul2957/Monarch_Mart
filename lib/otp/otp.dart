import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/otp/otp_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../app_utils/customWidget.dart';

// ignore: must_be_immutable
class Otp extends StatefulWidget {
  String? registrationMethod, emailorPhone, userId;

  Otp(
      {required this.registrationMethod,
      required this.emailorPhone,
      required this.userId});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late double width, height, statusbar;

  late OtpProvider provider;
  TextEditingController otpController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  initializeProperty(context) {
    provider = Provider.of<OtpProvider>(context, listen: false);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
  }

  var code1 = TextEditingController();
  var code2 = TextEditingController();
  var code3 = TextEditingController();
  var code4 = TextEditingController();
  var code5 = TextEditingController();
  var code6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initializeProperty(context);
    if (!provider.isInitialize) {
      provider.init(
          context: context,
          userId: widget.userId,
          regMethod: widget.registrationMethod);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: AppColor.primary)),
      ),
      body: SafeArea(
        child: Container(
          width: width * 100,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: width * 5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 46.h),
                  child: Container(
                    height: 36.h,
                    alignment: Alignment.center,
                    child: Text("Confirm OTP",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: AppColor.primary)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 96.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 260.w,
                        alignment: Alignment.center,
                        child: Text("We've sent an OTP in your phone",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                color: AppColor.lightBlack)),
                      ),
                      Container(
                        width: 260.w,
                        alignment: Alignment.center,
                        child: Text(widget.emailorPhone ?? "",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: AppColor.lightBlack)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                otpFieldNew(),
                SizedBox(height: height * 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.5,
                    fixedSize: Size(360.w, 50.h),
                    primary: AppColor.primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: height * 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    // String otpCode = code1.text +
                    //     code2.text +
                    //     code3.text +
                    //     code4.text +
                    //     code5.text +
                    //     code6.text;
                    String otpCode = otpController.text;
                    if (otpCode.length == 6) {
                      provider.confirmVerificationCode(
                          userId: widget.userId ?? "",
                          verificationCode: otpCode,
                          phone: widget.emailorPhone ?? "");
                    } else {
                      errorController!.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() => hasError = true);
                      Toast.createToast(
                          context: context,
                          message: "Invalid Otp",
                          duration: Duration(seconds: 1));
                    }
                  },
                  child: Obx(() => buildButtonTextLoader(
                    btnText: "Confirm",
                    showLoader: provider.loginController.otpVerifyLoader.value,
                  ))
                ),
                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: () {
                    provider.resendVerificationCode(
                        registrationMethod: widget.registrationMethod ?? "");
                  },
                  child: Container(
                    width: 124.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: AppColor.primary.withOpacity(0.3)),
                    child: Text(
                      "Resend Code",
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        color: AppColor.primary,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Widget otpFieldNew() {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: 6,
      // obscureText: true,
      // obscuringCharacter: '*',
      // obscuringWidget: const FlutterLogo(
      //   size: 24,
      // ),
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      // validator: (v) {
      //   if (v!.length < 6) {
      //     return "I'm from validator";
      //   } else {
      //     return null;
      //   }
      // },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 40,
        fieldWidth: 40,
        activeFillColor: Colors.white,
      ),
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      errorAnimationController: errorController,
      controller: otpController,
      keyboardType: TextInputType.number,
      boxShadows: const [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onCompleted: (v) {
        debugPrint("Completed");
      },
      // onTap: () {
      //   print("Pressed");
      // },
      onChanged: (value) {
        debugPrint(value);
        setState(() {
          currentText = value;
        });
      },
      beforeTextPaste: (text) {
        debugPrint("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }

  Widget otpField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OtpInput(
            controller: code1,
            isFocused: true,
            onChnaged: (otpCode) {
              setOtp(otpCode);
            }),
        OtpInput(
          controller: code2,
          isFocused: false,
          onChnaged: (otpCode) {
            setOtp(otpCode);
          },
        ),
        OtpInput(
          controller: code3,
          isFocused: false,
          onChnaged: (otpCode) {
            setOtp(otpCode);
          },
        ),
        OtpInput(
          controller: code4,
          isFocused: false,
          onChnaged: (otpCode) {
            setOtp(otpCode);
          },
        ),
        OtpInput(
          controller: code5,
          isFocused: false,
          onChnaged: (otpCode) {
            setOtp(otpCode);
          },
        ),
        OtpInput(
          controller: code6,
          isFocused: false,
          onChnaged: (otpCode) {
            setOtp(otpCode);
          },
        ),
      ],
    );
  }

  void setOtp(String otpCode) {
    if (otpCode.length >= 6) {
      code1.text = otpCode[0];
      code2.text = otpCode[1];
      code3.text = otpCode[2];
      code4.text = otpCode[3];
      code5.text = otpCode[4];
      code6.text = otpCode[5];
    }
  }
}
