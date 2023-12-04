import 'package:flutter/material.dart';

class SortingOption {
  static void create(
          {required double width,
          required double height,
          required String currentSortingCategory,
          required BuildContext context,
          required Function sortingFunction,
          required Offset offset}) =>
      showGeneralDialog(
          barrierColor: Colors.transparent,
          transitionDuration: Duration(milliseconds: 200),
          transitionBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new SlideTransition(
              child: child,
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
            );
          },
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return SortingOptionWindow(
              width: width,
              height: height,
              offset: offset,
              currentSortingCategory: currentSortingCategory,
              sortingFunction: sortingFunction,
            );
          });
}

// ignore: must_be_immutable
class SortingOptionWindow extends StatelessWidget {
  double width, height;
  Offset offset;
  Function sortingFunction;
  String currentSortingCategory;
  SortingOptionWindow(
      {required this.width,
      required this.height,
      required this.currentSortingCategory,
      required this.sortingFunction,
      required this.offset});
  List title = [
    "Default",
    "Price high to low",
    "Price low to high",
    "New Arraival",
    "Popularity",
    "Top Rated",
  ];
  List values = [
    "",
    "price_high_to_low",
    "price_low_to_high",
    "new_arrival",
    "popularity",
    "top_rated",
  ];

  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: offset.dy + height * 4,
              left: offset.dx - width * 13,
              child: GestureDetector(
                onTap: () {},
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                        width: width * 45.5,
                        height: height * 35,
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 3, vertical: height),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            heading(),
                            item(0),
                            item(1),
                            item(2),
                            item(3),
                            item(4),
                            item(5)
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

  Widget heading() {
    return Container(
      width: width * 38,
      padding: EdgeInsets.symmetric(vertical: height),
      child: Text(
        "Sort Products By",
        style: TextStyle(
            fontSize: height * 1.9,
            color: Colors.black87,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget item(int index) {
    return InkWell(
      onTap: () {
        sortingFunction(values[index]);
        Navigator.pop(context);
      },
      child: Container(
        height: height * 4.5,
        padding: EdgeInsets.only(right: width * 2),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            radioButton(currentSortingCategory.compareTo(values[index]) == 0),
            SizedBox(width: width * 2),
            Text(
              title[index],
              style: TextStyle(
                fontSize: height * 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget radioButton(bool active) {
    return Container(
      width: width * 4,
      height: width * 4,
      alignment: Alignment.center,
      padding: EdgeInsets.all(width * 0.4),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? Color(0xFF03A9F4) : Colors.black38,
            width: width * 0.4,
            style: BorderStyle.solid,
          )),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? Color(0xFF03A9F4) : Colors.transparent,
        ),
      ),
    );
  }
}
