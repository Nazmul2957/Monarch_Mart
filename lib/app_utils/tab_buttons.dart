// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';

class TabButton extends StatefulWidget {
  Function onClck;
  TabButton({required this.onClck});

  @override
  _TabButtonState createState() => _TabButtonState();
}

class _TabButtonState extends State<TabButton> {
  late double width, height;
  late List<bool> isPressed = [true, false, false];
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;
    return Container(
      width: width * 95,
      decoration: BoxDecoration(color: Color(0xFFE2E3E4).withOpacity(0.7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {
                change(0);
                widget.onClck(0);
              },
              child: singleButton("Description", 0)),
          InkWell(
              onTap: () {
                change(1);
                widget.onClck(1);
              },
              child: singleButton("Review", 1)),
          InkWell(
              onTap: () {
                change(2);
                widget.onClck(2);
              },
              child: singleButton("Policy", 2)),
        ],
      ),
    );
  }

  void change(int i) {
    setState(() {
      isPressed = List.generate(3, (index) {
        if (i == index) {
          return true;
        } else {
          return false;
        }
      });
    });
  }

  Widget singleButton(String title, int i) {
    return Container(
        height: height * 4.75,
        width: width * 31,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: new LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  isPressed[i] == true ? AppColor.primary : Colors.transparent,
                  isPressed[i] == true ? AppColor.primary : Colors.transparent,
                ])),
        padding:
            EdgeInsets.symmetric(horizontal: width * 2, vertical: height / 2),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: height * 1.5,
              color: isPressed[i] == true
                  ? Colors.white
                  : Colors.black.withOpacity(0.6)),
        ));
  }
}
