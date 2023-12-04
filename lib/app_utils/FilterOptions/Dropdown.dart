import 'package:flutter/material.dart';

class Dropdown {
  static void create({
    required double width,
    required double height,
    required BuildContext context,
    required Function? onClick,
    required double dx,
    required double dy,
  }) =>
      showGeneralDialog(
          barrierColor: Colors.transparent,
          transitionDuration: Duration(milliseconds: 200),
          transitionBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new SlideTransition(
              child: child,
              position: new Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
            );
          },
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return DropdownWindow(
              width: width,
              height: height,
              context: context,
              dx: dx,
              dy: dy,
              onClick: onClick,
            );
          });
}

// ignore: must_be_immutable
class DropdownWindow extends StatelessWidget {
  double width, height, dx, dy;
  BuildContext context;
  Function? onClick;

  DropdownWindow({
    required this.width,
    required this.height,
    required this.context,
    required this.onClick,
    required this.dx,
    required this.dy,
  });

  List title = ["Brands", "Product", "Sellers"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: dy + height * 4,
              left: dx,
              child: GestureDetector(
                onTap: () {},
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                        width: width * 32.4,
                        height: height * 18,
                        decoration:
                        BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: width / 10,
                            blurRadius: height / 4,
                            offset: Offset(width / 5, width / 2),
                          ),
                        ]),
                        child: Column(
                          children: [
                            item(0),
                            Divider(color: Colors.grey),
                            item(1),
                            Divider(color: Colors.grey),
                            item(2)
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(int index) {
    return InkWell(
      onTap: () {
        onClick!(title[index]);
        Navigator.pop(context);
      },
      child: Container(
        height: height * 4.5,
        width: width * 32.4,
        padding: EdgeInsets.only(right: width * 2),
        alignment: Alignment.center,
        child: Text(
          title[index],
          style: TextStyle(
            fontSize: height * 1.6,
          ),
        ),
      ),
    );
  }
}
