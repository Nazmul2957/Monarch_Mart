// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  Function category;
  String dropdownOption;
  Function filter;
  Function sort;

  bool isEnabled;
  FilterBar(
      {required this.category,
      required this.filter,
      required this.sort,
      required this.dropdownOption,
      required this.isEnabled});
  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late double width, height, statusbar;

  late GlobalKey mykey = new GlobalKey();

  late GlobalKey mykey1 = new GlobalKey();

  late Offset offset;

  Offset getOffset(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Widget _dropDownButton(String currentCat) {
    return InkWell(
      key: mykey,
      onTap: () {
        offset = getOffset(mykey);
        widget.category(offset);
      },
      child: Container(
        width: width * 32.5,
        height: height * 4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            width: width / 10,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.dropdownOption,
              style: TextStyle(fontSize: height * 1.6, color: Colors.black87),
            ),
            SizedBox(width: width),
            Icon(
              Icons.expand_more,
              size: height * 2,
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }

  Widget _filterOptions(int index, String title) {
    return InkWell(
      key: index == 1 ? mykey1 : null,
      onTap: () {
        if (widget.isEnabled) {
          if (index == 1) {
            offset = getOffset(mykey1);
            //this portion open sorting window
            widget.sort(offset);
          } else {
            //this portion open enddrawers
            widget.filter();
          }
        }
      },
      child: Container(
        width: width * 32.5,
        height: height * 4,
        decoration: BoxDecoration(
          border: Border.all(
            width: width / 10,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              index == 0 ? Icons.filter_alt : Icons.swap_vert,
              size: height * 2,
              color: widget.isEnabled
                  ? Colors.black87
                  : Colors.grey.withOpacity(0.5),
            ),
            SizedBox(width: width),
            Text(
              title,
              style: TextStyle(
                fontSize: height * 1.6,
                color: widget.isEnabled
                    ? Colors.black87
                    : Colors.grey.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;

    return Container(
      height: height * 4,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: width / 2,
          blurRadius: height / 2,
          offset: Offset(0, width / 5),
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _dropDownButton(widget.dropdownOption),
          _filterOptions(0, "Filter"),
          _filterOptions(1, "Sort")
        ],
      ),
    );
  }
}
