import 'package:flutter/material.dart';
import 'package:monarch_mart/filtered_products/filter_provider.dart';

// ignore: must_be_immutable
class EndDrawer extends StatefulWidget {
  double width, height;
  FilterProvider presenter;
  EndDrawer(
      {required this.width, required this.height, required this.presenter});

  @override
  _EndDrawerState createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  late String? selectedCategoriesId = widget.presenter.selectedCategories,
      selectedBrandsId = widget.presenter.selectedBrands,
      minimumPrice = widget.presenter.minimumPrice,
      maximumPrice = widget.presenter.maximumPrice;
  var minimumController = new TextEditingController();
  var maximumController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      minimumController.text = minimumPrice.toString();
      maximumController.text = maximumPrice.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 60,
      padding: EdgeInsets.fromLTRB(
          widget.width * 4, widget.height * 6, widget.width * 2, 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(),
          SizedBox(height: widget.height * 2),
          priceRange(),
          SizedBox(height: widget.height),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [
              widget.presenter.categoryresponse!.data!.isNotEmpty
                  ? categoryPane()
                  : Container(),
              SizedBox(height: widget.height * 2),
              widget.presenter.brandResponse!.data!.isNotEmpty
                  ? brandsPane()
                  : Container(),
            ],
          )),
          SizedBox(height: widget.height),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              bottomButtons(false, "Clear"),
              bottomButtons(true, "Okay"),
            ],
          ),
          SizedBox(height: widget.height * 4),
        ],
      ),
    );
  }

  Widget backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: widget.width * 60,
        alignment: Alignment.topLeft,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black87,
          size: widget.height * 3,
        ),
      ),
    );
  }

  Widget priceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingTitles("Price Range"),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            searchBoxItems(minimumController, "Minimum", true),
            Text("  -  "),
            searchBoxItems(maximumController, "Maximum", false),
          ],
        )
      ],
    );
  }

  Widget searchBoxItems(controller, String hints, bool option) {
    return Container(
      width: widget.width * 23,
      height: widget.height * 4,
      alignment: Alignment.centerLeft,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (v) {},
        style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 0.8),
          fontFamily: "Poppins",
          fontSize: widget.height * 1.8,
        ),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: hints,
            hintStyle:
                TextStyle(fontSize: widget.height * 1.6, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey, width: widget.width / 5),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey, width: widget.width / 5),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            contentPadding: EdgeInsets.all(widget.width / 2)),
      ),
    );
  }

  Widget categoryPane() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingTitles("Categories"),
        widget.presenter.categoryresponse != null
            ? widget.presenter.categoryresponse!.data!.length != 0
                ? categoryList()
                : dataText()
            : dataText()
      ],
    );
  }

  Widget dataText() {
    return Text(
      "No data Availabe",
      style: TextStyle(
        fontSize: widget.height * 1.6,
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget brandsPane() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingTitles("Brands"),
        widget.presenter.brandResponse != null
            ? widget.presenter.brandResponse!.data!.length != 0
                ? brandList()
                : dataText()
            : dataText(),
      ],
    );
  }

  Widget headingTitles(String title) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: widget.height * 1.25),
        child: Text(
          title,
          style: TextStyle(
            fontSize: widget.height * 1.7,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ));
  }

  Widget categoryList() {
    return SingleChildScrollView(
        child: ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.presenter.categoryresponse!.data!.length,
      itemBuilder: (context, index) => CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        value: selectedCategoriesId!.compareTo(widget
                .presenter.categoryresponse!.data![index].id
                .toString()) ==
            0,
        title: Text(
            widget.presenter.categoryresponse!.data![index].name.toString()),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              selectedCategoriesId =
                  widget.presenter.categoryresponse!.data![index].id.toString();
            } else {
              selectedCategoriesId = "";
            }
          });
        },
      ),
    ));
  }

  Widget brandList() {
    return SingleChildScrollView(
        child: ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.presenter.brandResponse!.data!.length,
      itemBuilder: (context, index) => CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        value: selectedBrandsId!.compareTo(
                widget.presenter.brandResponse!.data![index].id.toString()) ==
            0,
        title:
            Text(widget.presenter.brandResponse!.data![index].name.toString()),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              selectedBrandsId =
                  widget.presenter.brandResponse!.data![index].id.toString();
            } else {
              selectedBrandsId = "";
            }
          });
        },
      ),
    ));
  }

  Widget bottomButtons(bool v, String title) {
    return InkWell(
      onTap: () {
        if (v) {
          widget.presenter.setFilterCategory(
              minimumController.text,
              maximumController.text,
              selectedCategoriesId.toString(),
              selectedBrandsId.toString());
        } else {
          widget.presenter.setFilterCategory("", "", "", "");
        }
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: widget.width * 18,
        height: widget.height * 3,
        decoration: BoxDecoration(
          color: v ? Colors.green : Colors.red,
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: widget.height * 1.6, color: Colors.white),
        ),
      ),
    );
  }
}
