import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_font.dart';
import 'package:monarch_mart/app_components/app_image.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/customWidget.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'ProfileEditProvider.dart';

// ignore: must_be_immutable
class ProfileEdit extends StatelessWidget {
  late double width, height, statusbar;
  late ProfileEditProvider provider;

  var node1 = new FocusNode();
  var node2 = new FocusNode();
  var node3 = new FocusNode();
  var nameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var confirmPasswordController = new TextEditingController();

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    provider = Provider.of<ProfileEditProvider>(context, listen: false);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;

    if (!provider.isInitialize) {
      provider.init(context: context);
      nameController.text = provider.userName.toString();
      passwordController.text = provider.userPassword.toString();
      confirmPasswordController.text = provider.userPassword.toString();
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: Myappbar(context).appBarCommon(title: "Edit Profile"),
        body: Container(
          padding: EdgeInsets.only(left: width * 5, right: width * 5),
          child: Column(
            children: [
              profileImage(),
              SizedBox(height: height * 5),
              Divider(height: height / 5),
              SizedBox(height: height * 5),
              Container(
                width: width * 90,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: height * 2,
                    fontFamily: AppFont.Poppins,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
              ),
              SizedBox(height: height * 2),
              EditText(
                  controller: nameController,
                  width: width,
                  height: height,
                  hints: ""),
              editText("Name", nameController, node1),
              SizedBox(height: height),
              editText("Password", passwordController, node2),
              Container(
                width: width * 90,
                alignment: Alignment.centerRight,
                child: Text(
                  "Password must be at least 6 character",
                  style: TextStyle(
                      color: AppColor.secondary, fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: height),
              editText("Confirm Password", confirmPasswordController, node3),
              SizedBox(height: height),
              Container(
                width: width * 90,
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 35, height * 5),
                        primary: AppColor.primary,
                        textStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      String message = provider.validator(
                          nameController.text,
                          passwordController.text,
                          confirmPasswordController.text);

                      if (message.contains("true")) {
                        provider.updateProfile(
                            name: nameController.text,
                            password: passwordController.text);
                      } else {
                        Toast.createToast(
                            context: context,
                            message: message,
                            duration: Duration(milliseconds: 1000));
                      }
                    },
                    child: Obx(
                      () => buildButtonTextLoader(
                          btnText: "Update Profile",
                          showLoader: provider
                              .loaderController.profileUpdateLoader.value),
                    )),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  Widget profileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Consumer<ProfileEditProvider>(
          builder: (context, value, child) => Container(
            width: width * 30,
            height: width * 30,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(width * 15),
                child: CachedImage(
                    placeHolder: AppImage.profilePlaceholder,
                    imageUrl: provider.avater.toString())),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            chooseAndUploadImage(context);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width * 6, width * 6),
            shape: CircleBorder(),
          ),
          child: Icon(Icons.edit_sharp, size: height * 2),
        ),
      ],
    );
  }

  Widget editText(String title, controller, FocusNode node) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: height / 2),
          child: Text(
            title,
            style: TextStyle(
                fontSize: height * 1.7,
                fontFamily: AppFont.Poppins,
                color: AppColor.primary,
                fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: height * 5,
              child: TextFormField(
                controller: controller,
                focusNode: node,
                autofocus: false,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: height * 1.8),
                textAlignVertical: TextAlignVertical.center,
                obscureText: title.contains("Password"),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary)),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void chooseAndUploadImage(context) async {
    var status = await Permission.storage.status;

    if (status == PermissionStatus.granted) {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = File(image.path).readAsBytesSync();
        String base64Image = base64Encode(bytes);
        String fileName = image.name;
        provider.updateImage(image: base64Image, filename: fileName);
      }

      if (image == null) {
        Toast.createToast(
            context: context,
            message: "No File Choosen!!!",
            duration: Duration(milliseconds: 1000));
        return;
      }
    } else if (status == PermissionStatus.denied) {
      await Permission.storage.request();
    } else {
      openAppSettings();
    }
  }
}
