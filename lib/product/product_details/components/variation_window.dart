// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_models/variation.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/mycolor.dart';
import 'package:provider/provider.dart';

import '../product_details_provider.dart';

class VariationWindow extends StatelessWidget {
  ProductDetailsProvider presenter;
  double width, height;

  VariationWindow(
      {required this.presenter, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, ob, child) {
        if (ob.response != null) {
          if (ob.variationList!.isNotEmpty) {
            if (ob.variationList![0].sizeOptions!.isEmpty &&
                ob.variationList!.length == 1) {
              return Container();
            } else {
              return variationOptions();
            }
          } else {
            return Container();
          }
        } else {
          return AppShimer(width: width * 90, height: height * 5);
        }
      },
    );
  }

  Widget variationOptions() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: width * 2.5),
      itemCount: presenter.variationList!.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: height,
        crossAxisSpacing: width * 5,
        childAspectRatio: ((width * 46) / (height * 8)),
      ),
      itemBuilder: (context, index) {
        return variationFunc(presenter.variationList![index], index);
      },
    );
  }

  Widget variationFunc(Variation variation, int index) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              variation.title.toString(),
              style: TextStyle(
                fontSize: height * 2,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          variation.title == "Color"
              ? colorOptionList(variation, index)
              : choiceOptionList(variation, index),
        ],
      ),
    );
  }

  Widget arrowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.arrow_back_ios,
          size: height * 1.8,
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: height * 1.8,
        )
      ],
    );
  }

  Widget choiceOptionList(Variation variation, int index) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: variation.sizeOptions!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(
                right: width, top: height / 2, bottom: height / 2),
            child: InkWell(
              onTap: () {
                presenter.changeVariation(variation, index, i);
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: width * 10),
                child: Container(
                  alignment: Alignment.center,
                  height: width * 10,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: variation.selectedOption == i
                          ? Colors.black
                          : Colors.grey.withOpacity(0.6),
                      width: width / 3,
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                  child: Text(
                    variation.sizeOptions![i].toString(),
                    style: TextStyle(
                      fontSize: height * 1.5,
                      color: variation.selectedOption == i
                          ? Colors.black
                          : Colors.grey.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget colorOptionList(Variation variation, int index) {
    return Expanded(
      child: ListView.builder(
        itemCount: variation.sizeOptions!.length,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(
                right: width * 2, top: height / 2, bottom: height / 2),
            child: GestureDetector(
              onTap: () {
                presenter.changeVariation(variation, index, i);
              },
              child: Container(
                alignment: Alignment.center,
                width: width * 10,
                height: width * 10,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(height / 2),
                  border: Border.all(
                      width: width / 3, color: Colors.grey.withOpacity(0.6)),
                  color: MyColor.getColor(variation.sizeOptions![i]),
                  // border: Border.all(
                  //   color: colors[index].compareTo(presenter.selectedColor) == 0 ? Colors.purple : Colors.teal,
                  //   width: width / 2,
                  // ),
                ),
                child: Icon(
                  Icons.done_outline,
                  color: variation.selectedOption == i
                      ? Colors.white
                      : Colors.transparent,
                  size: height * 2.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
