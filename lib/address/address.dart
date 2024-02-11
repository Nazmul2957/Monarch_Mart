// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:monarch_mart/core/app_export.dart';
import 'components/address_dialog.dart';

class Address extends StatelessWidget {
  late double width, height, statusbar;
  late AddressProvider provider;
  late BuildContext context;
  String? ownerId;
  bool isFromCart;

  Address({this.ownerId, this.isFromCart = false});

  Future onRefresh() async {
    provider.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    provider = Provider.of<AddressProvider>(context, listen: false);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    if (!provider.isInitialize) {
      provider.init(context: context, ownerId: ownerId);
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: isFromCart
            ? Myappbar(context).appBarShipping()
            : Myappbar(context).appBarCommon(title: "Addresses of User"),
        body: Column(
          children: [
            Container(height: height * 6, child: addAddress()),
            Expanded(
              child: Consumer<AddressProvider>(
                builder: (context, ob, child) {
                  if (ob.addressResponse != null) {
                    if (ob.dataModel.isNotEmpty) {
                      return RefreshIndicator(
                        color: AppColor.secondary,
                        backgroundColor: Colors.white,
                        onRefresh: onRefresh,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: width * 5),
                          scrollDirection: Axis.vertical,
                          itemCount: ob.dataModel.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.symmetric(vertical: height),
                                child: addressCard(ob.dataModel[index], index));
                          },
                        ),
                      );
                    } else {
                      return Center(child: Text("No Address available"));
                    }
                  } else {
                    return shimer();
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: ListView(
          shrinkWrap: true,
          children: [
            isFromCart ? bottomButton() : Container(height: 0),
            AppBottomNavigation()
          ],
        ),
      ),
    );
  }

  Widget bottomButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 5, vertical: height),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: AppColor.primary,
              fixedSize: Size(width * 90, height * 6),
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: height * 1.8,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            if (provider.dataModel.isNotEmpty) {
              provider.updateAddressForDelivery(
                  addressId: provider.selectedAddressId!);
              Navigator.pushNamed(context, AppRoute.checkout,
                  arguments: ScreenArguments(data: {"ownerId": ownerId}));
            } else {
              Toast.createToast(
                  context: context,
                  message: "Please Provide an Address for Shipment",
                  duration: Duration(seconds: 2));
            }
          },
          child: Obx(
            () => buildButtonTextLoader(
                btnText: "Proceed to payment",
                showLoader: provider.loaderController.paymentLoader.value),
          )),
    );
  }

  Widget addAddress() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width * 90, height * 5),
          primary: AppColor.primary,
        ),
        onPressed: () {
          AddressDialog.openWindow(context, provider, true, 0);
        },
        child: Icon(
          Icons.add,
          size: height * 4,
          color: AppColor.white,
        ));
  }

  Widget addressCard(AddressDataModel model, int index) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            if (model.setDefault == 0) {
              provider.setDefaultAddress(
                  index: index, addressId: model.id.toString());
            }
          },
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: width * 3, vertical: height),
            width: width * 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height),
              border: Border.all(
                color: AppColor.primary,
                width: width / 5,
              ),
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    singleRecordRow("Address", model.address),
                    singleRecordRow("City", model.city),
                    singleRecordRow("Postal Code", model.postalCode),
                    singleRecordRow("Country", model.country),
                    singleRecordRow("Phone", model.phone),
                    defaultAddress(model, index),
                  ],
                ),
                Container(
                  width: width * 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      modifyButton(Icons.edit, model.id!, "edit", index,
                          model.setDefault!),
                      SizedBox(height: height),
                      modifyButton(Icons.delete_forever, model.id!, "delete",
                          index, model.setDefault!),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        isFromCart
            ? model.setDefault == 1
                ? Padding(
                    padding:
                        EdgeInsets.only(top: height / 2, right: width * 1.5),
                    child: Icon(Icons.check_circle,
                        size: height * 2.5, color: Colors.green),
                  )
                : Container()
            : Container()
      ],
    );
  }

  Widget modifyButton(
      IconData icons, int id, String button, int index, int setDefault) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: width / 10, color: AppColor.primary),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: InkWell(
        onTap: () {
          if (button.contains("edit")) {
            AddressDialog.openWindow(context, provider, false, index);
          } else {
            if (setDefault != 1) {
              provider.deleteAddress(index: index, addressId: id);
            } else {
              Toast.createToast(
                context: context,
                message: "Change Default Address First!!",
                duration: Duration(milliseconds: 1000),
              );
            }
          }
        },
        child: Container(
          width: width * 8,
          height: width * 8,
          child: Icon(
            icons,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget singleRecordRow(String title, String? fieldValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width * 30,
          height: height * 3,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: AppColor.black,
            ),
          ),
        ),
        Container(
          width: width * 50,
          height: height * 3,
          alignment: Alignment.centerLeft,
          child: Text(
            fieldValue ?? "",
            maxLines: 2,
            style:
                TextStyle(color: AppColor.black, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget defaultAddress(AddressDataModel model, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 1.5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: width * 30,
          height: height * 3,
          alignment: Alignment.centerLeft,
          child: Text(
            "Default Address",
            style: TextStyle(
              color: AppColor.black,
            ),
          ),
        ),
        Container(
          width: height * 3,
          height: height * 3,
          alignment: Alignment.centerLeft,
          child: Checkbox(
            value: model.setDefault == 1,
            checkColor: AppColor.black,
            activeColor: Colors.green,
            onChanged: (value) {
              if (model.setDefault == 0) {
                provider.setDefaultAddress(
                    index: index, addressId: model.id.toString());
              }
            },
          ),
        ),
        Container(
          height: height * 3,
          alignment: Alignment.centerLeft,
          child: Text(
            "tap to make this default",
            style: TextStyle(color: Colors.black38, fontSize: height * 1.2),
          ),
        )
      ]),
    );
  }

  Widget shimer() {
    return ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: width * 5),
        itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: height),
            child: AppShimer(
              width: width * 90,
              height: height * 15,
              borderRadius: height,
            )));
  }
}
