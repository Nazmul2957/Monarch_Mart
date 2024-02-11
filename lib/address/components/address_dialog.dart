import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:get/get.dart';
import '../address_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddressDialog {
  static void openWindow(BuildContext context, AddressProvider presenter,
          bool isAdd, int index) =>
      showDialog(
          context: context,
          builder: (context) => AddressWindow(
                presenter: presenter,
                isAdd: isAdd,
                index: index,
              ));
}

// ignore: must_be_immutable
class AddressWindow extends StatefulWidget {
  AddressProvider presenter;
  bool isAdd;
  int index;

  AddressWindow(
      {required this.presenter, required this.isAdd, required this.index});

  @override
  _AddressWindowState createState() =>
      _AddressWindowState(presenter, isAdd, index);
}

class _AddressWindowState extends State<AddressWindow> {
  late double width, height, statusbar;
  var addressController = new TextEditingController();
  var postCodeController = new TextEditingController();
  var phoneController = new TextEditingController();
  var nameController = new TextEditingController();
  late AddressProvider presenter;
  bool isAdd;
  int index;
  String name = "";
  String selectedCityName = "",
      selectedCountryName = "",
      address = "",
      postCode = "",
      phoneNumber = "",
      dob = DateFormat("yyyy-MM-dd").format(DateTime.now()),
      gender = "Male";
  List<String> genders = ["Male", "Female", "Others"];

  _AddressWindowState(this.presenter, this.isAdd, this.index) {
    if (!isAdd) {
      selectedCityName = presenter.dataModel[index].city!;
      selectedCountryName = presenter.dataModel[index].country!;
      addressController.text = presenter.dataModel[index].address!;
      postCodeController.text = presenter.dataModel[index].postalCode!;
      nameController.text=presenter.dataModel[index].name!;
      dob=presenter.dataModel[index].dob!;
      gender=presenter.dataModel[index].gender!;
      phoneController.text = presenter.dataModel[index].phone!.substring(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;

    return Dialog(
      child: Container(
          width: width * 90,
          height: height * 80,
          padding:
              EdgeInsets.symmetric(horizontal: width * 5, vertical: height * 2),
          child: ListView(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    editText("Name ", nameController, "Enter Name"),
                    birthdate(),
                    genderDropdown(),
                    editText("Address *", addressController, "Enter Address"),
                    editText("Postal", postCodeController, "Enter Postal Code"),
                    dropdown(
                        "City *", "Enter City Name", presenter.cityList, true),
                    editText("Phone *", phoneController, "Enter Number"),
                    /* dropdown("Country *", "Enter Country Name",
                        presenter.countryList, false),*/
                    Container(
                      width: width * 90,
                      height: height * 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buttons("Cancel", Colors.redAccent),
                          buttons(
                              widget.isAdd ? "Save" : "Update", Colors.green),
                        ],
                      ),
                    ),
                  ]),
            ],
          )),
    );
  }

  Widget buttons(String title, Color color) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: color,
          //  fixedSize: Size(width * 30, height * 5),
            alignment: Alignment.center,
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: height * 1.7,
            )),
        onPressed: () {
          if (title.contains("Save")) {
            if (isValid()) {
              presenter.addAddress(
                  name: nameController.text,
                  address: address,
                  /*  country: selectedCountryName,*/
                  city: selectedCityName,
                  postalCode: postCode,
                  phone: phoneNumber,
                  dob: dob,
                  gender: gender,
                  dialogContext: context);
            }
          } else if (title.contains("Update")) {
            if (isValid()) {
              presenter.updateAddress(
                  id: presenter.dataModel[index].id.toString(),
                  name: nameController.text,
                  address: address,
                  country: selectedCountryName,
                  city: selectedCityName,
                  postalCode: postCode,
                  phone: phoneNumber,
                  dob: dob,
                  gender: gender,
                  dialogContext: context);
            }
          } else {
            Navigator.pop(context);
          }
        },
        child: Text(title));
  }

  Widget editText(String title, controller, String hints) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(color: AppColor.black, fontSize: height * 1.8),
      ),
      SizedBox(height: height / 2),
      Container(
        height: height * 6,
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: height * 1.7),
          autofocus: false,
          maxLines: title.contains("Address") ? 2 : 1,
          keyboardType: title.contains("Address")
              ? TextInputType.multiline
              : TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: hints,
            hintStyle:
                TextStyle(fontSize: height * 1.6, color: AppColor.secondary),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.secondary, width: width / 5),
                borderRadius: BorderRadius.circular(height)),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor.secondary, width: width / 5),
              borderRadius: BorderRadius.circular(height),
            ),
            contentPadding:
                EdgeInsets.only(left: height / 2, top: height, bottom: height),
          ),
        ),
      ),
    ]);
  }

  Widget dropdown(
      String title, String hints, List<String> itemlist, bool isCity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(color: AppColor.black, fontSize: height * 1.8)),
        SizedBox(height: height / 2),
        Container(
          height: height * 6,
          child: DropdownSearch<String>(
            items: itemlist,
            maxHeight: height * 30,
            dialogMaxWidth: width * 90,
            selectedItem: isCity ? selectedCityName : selectedCountryName,
            showSearchBox: true,
            dropdownSearchDecoration: InputDecoration(
                hintText: hints,
                hintStyle: TextStyle(
                    fontSize: height * 1.7, color: AppColor.secondary),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.secondary, width: width / 5),
                    borderRadius: BorderRadius.circular(height)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.secondary, width: width / 5),
                    borderRadius: BorderRadius.circular(height)),
                contentPadding: EdgeInsets.only(left: width * 2)),
            onChanged: (selected) {
              setState(() {
                if (isCity) {
                  selectedCityName = selected ?? "";
                } else {
                  selectedCountryName = selected ?? "";
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget birthdate() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Date of Birth",
        style: TextStyle(color: AppColor.black, fontSize: height * 1.8),
      ),
      SizedBox(height: height / 2),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.secondary, width: width / 5),
          borderRadius: BorderRadius.circular(height),
        ),
        child: InkWell(
          onTap: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2080))
                .then((value) {
              try {
                var outputFormat = DateFormat('yyyy-MM-dd');
                setState(() {
                  dob = outputFormat.format(value as DateTime);
                });
              } catch (e) {}
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height * 6,
                padding: EdgeInsets.only(left: width * 2),
                alignment: Alignment.centerLeft,
                child: Text(dob),
              ),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
      )
    ]);
  }

  Widget genderDropdown() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Gender",
        style: TextStyle(color: AppColor.black, fontSize: height * 1.8),
      ),
      SizedBox(height: height / 2),
      Container(
        padding: EdgeInsets.only(left: width * 2),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.secondary, width: width / 5),
          borderRadius: BorderRadius.circular(height),
        ),
        child: DropdownButton(
          value: gender,
          isExpanded: true,
          underline: Container(),
          onChanged: (newValue) {
            setState(() {
              gender = newValue.toString();
            });
          },
          items: genders.map((gen) {
            return DropdownMenuItem(
              child: new Text(gen),
              value: gen,
            );
          }).toList(),
        ),
      ),
    ]);
  }

  bool isValid() {
    address = addressController.text;
    postCode = postCodeController.text;
    phoneNumber = phoneController.text;
    name = nameController.text;

    if (!name.isEmpty) {
      if (!address.isEmpty) {
        if (!phoneNumber.isEmpty) {
          if (phoneNumber.length == 11 && phoneNumberIsValid(phoneNumber)) {
            if (!selectedCityName.isEmpty) {
              return true;
              /* if (!selectedCountryName.isEmpty) {
                return true;
              } else {
                Get.snackbar("Error", "Please Enter Country",
                    backgroundColor: Colors.red);
              }*/
            } else {
              Get.snackbar("Error", "Please Enter City",
                  backgroundColor: Colors.red);
            }
          } else {
            Get.snackbar("Error", "Please Enter Valid Phone Number",
                backgroundColor: Colors.red);
          }
        } else {
          Get.snackbar("Error", "Please Enter Your Phone Number",
              backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar("Error", "Please Enter Address",
            backgroundColor: Colors.red);
      }
    } else {
      Get.snackbar("Error", "Please Enter Name", backgroundColor: Colors.red);
    }
    return false;

    /* return address.isNotEmpty &
        postCode.isNotEmpty &
        phoneNumber.isNotEmpty &
        selectedCityName.isNotEmpty &
        selectedCountryName.isNotEmpty &
        dob.isNotEmpty &
        gender.isNotEmpty;*/
  }

  bool phoneNumberIsValid(String number) {
    if (number.length == 11) {
      String operatorNo = number[2];
      if (number[0] == "0") {
        if (number[1] == "1") {
          if (operatorNo == "3" ||
              operatorNo == "4" ||
              operatorNo == "5" ||
              operatorNo == "6" ||
              operatorNo == "7" ||
              operatorNo == "8" ||
              operatorNo == "9") {
            return true;
          } else
            return false;
        } else
          return false;
      } else
        return false;
    } else
      return false;
  }
}
