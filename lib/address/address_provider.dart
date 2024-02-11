import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:monarch_mart/core/app_export.dart';

import '../controllers/loader_controller.dart';

class AddressProvider extends ChangeNotifier {
  final LoaderController loaderController = Get.find();
  late SharedPreferences preferences;
  String? accessToken, userId;
  bool isInitialize = false;
  late BuildContext context, dialogContext;
  List<AddressDataModel> dataModel = [];
  List<String> cityList = [];
  List<String> countryList = [];
  var dataHolder;
  AddressResponse? addressResponse;
  CityResponse? cityResponse;
  CountryResponse? countryResponse;
  CommonResponse? commonResponse;

  // NetworkProgress progress = new NetworkProgress();

  String? shippingCostString = "",
      selectedCity = "",
      ownerId = "",
      shippingCost = "0";
  int? selectedAddressId;

  init({required BuildContext context, String? ownerId}) {
    isInitialize = true;
    this.context = context;
    this.ownerId = ownerId;
    getUserInfo().then((list) {
      this.accessToken = list[0];
      this.userId = list[1];
      getAddressLists();
      getCityList();
      getCountryList();
    });
  }

  refreshAll() {
    addressResponse = null;
    dataModel = [];
    notifyListeners();
    getAddressLists();
    getCityList();
    getCountryList();
  }

  Future<List> getUserInfo() async {
    preferences = await SharedPreferences.getInstance();
    List<String?> holder = [];
    holder.add(preferences.getString(AppConstant.ACCESS_TOKEN));
    holder.add(preferences.getString(AppConstant.USER_ID));

    return holder;
  }

  Future getCityList() async {
    cityList = [];

    var caller = await MyClient.get(endpoint: "/cities");
    if (caller.statusCode == 200) {
      cityResponse = CityResponse.fromJson(jsonDecode(caller.body));
      if (cityResponse!.success!) {
        cityResponse!.data!.forEach((city) {
          cityList.sort((a, b) {
            return a.compareTo(b);
          });
          cityList.add(city.name!);
        });
        notifyListeners();
      }
    }
  }

  Future getCountryList() async {
    countryList = [];

    var caller = await MyClient.get(endpoint: "/countries");
    if (caller.statusCode == 200) {
      countryResponse = CountryResponse.fromJson(jsonDecode(caller.body));
      if (countryResponse!.success!) {
        countryResponse!.data!.forEach((country) {
          countryList.add(country.name!);
        });
      }
    }
  }

  void addAddress({
    required String address,
    /*required String country,*/
    required String city,
    required String postalCode,
    required String phone,
    required String dob,
    required String gender,
    required String name,
    required BuildContext dialogContext,
  }) {
    this.dialogContext = dialogContext;
    // progress.showProgress(dialogContext);
    postNewAddressToServer(
      address: address,
      /*   country: "Bangladesh",*/
      city: city,
      postalCode: postalCode,
      phone: phone,
      gender: gender,
      name: name,
      dob: dob,
    ).then((value) {
      // progress.closeDialog();
      caseHandler(value);
      if (value == AppConstant.SUCCESS) {
        getAddressLists();
        Navigator.pop(dialogContext);
      }
    });
  }

  void updateAddress(
      {required String id,
      required String address,
      required String country,
      required String city,
      required String postalCode,
      required String phone,
      required String dob,
      required String gender,
      required String name,
      required BuildContext dialogContext}) {
    this.dialogContext = dialogContext;
    // progress.showProgress(dialogContext);
    postUpdateAddressOnServer(
            id: id,
            name: name,
            address: address,
            country: country,
            city: city,
            postalCode: postalCode,
            dob: dob,
            gender: gender,
            phone: phone)
        .then((value) {
      // progress.closeDialog();
      caseHandler(value);
      if (value == AppConstant.SUCCESS) {
        getAddressLists();
        Navigator.pop(dialogContext);
      }
    });
  }

  void setDefaultAddress({required int index, required String addressId}) {
    dataModel.forEach((model) {
      model.setDefault = 0;
    });
    dataModel[index].setDefault = 1;
    selectedAddressId = dataModel[index].id;
    postToGetShippingCost(
        ownerId: ownerId.toString(),
        cityName: dataModel[index].city.toString());
    notifyListeners();

    postDefaultAddress(addressId: addressId.toString(), index: index)
        .then((value) {
      if (value == AppConstant.SUCCESS) {
        dataModel[index].setDefault = 1;
      } else {
        dataModel[index].setDefault = 0;
      }
      caseHandler(value);
    });
  }

  void deleteAddress({required int index, required int addressId}) {
    dataHolder = this.dataModel.removeAt(index);
    notifyListeners();
    postAddressForDeletation(addressId: addressId, index: index).then((value) {
      caseHandler(value);
    });
  }

  Future getAddressLists() async {
    dataModel = [];

    try {
      var caller = await MyClient.get(
          endpoint: "/user/shipping/address/" + userId.toString());
      addressResponse = AddressResponse.fromJson(jsonDecode(caller.body));

      addressResponse!.data!.forEach((dataElement) {
        if (dataElement.setDefault == 1) {
          selectedCity = dataElement.city;
          selectedAddressId = dataElement.id;
        }
        dataModel.add(AddressDataModel(
            address: dataElement.address,
            city: dataElement.city,
            country: dataElement.country,
            phone: dataElement.phone,
            name: dataElement.name,
            gender: dataElement.gender,
            dob: dataElement.dob,
            postalCode: dataElement.postalCode,
            setDefault: dataElement.setDefault,
            userId: dataElement.userId,
            id: dataElement.id));
      });
      notifyListeners();
      postToGetShippingCost(
          ownerId: ownerId.toString(), cityName: selectedCity.toString());
    } catch (e) {}
  }

  Future<int> postNewAddressToServer(
      {required String address,
      required String name,
      /* required String country,*/
      required String city,
      required String postalCode,
      required String dob,
      required String gender,
      required String phone}) async {
    var body = {
      "user_id": userId,
      "address": address,
      "country": "Bangladesh",
      "birth_date": dob,
      "name": name,
      "gender": gender,
      "city": city,
      "postal_code": postalCode,
      "phone": phone
    };
    print(body);
    print("address body");
    try {
      var caller = await MyClient.post(
          endpoint: "/user/shipping/create", bodyData: body);

      commonResponse = CommonResponse.fromJson(jsonDecode(caller.body));

      if (commonResponse!.result) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> postUpdateAddressOnServer(
      {required String id,
      required String dob,
      required String name,
      required String gender,
      required String address,
      required String country,
      required String city,
      required String postalCode,
      required String phone}) async {
    var body = {
      "user_id": userId,
      "id": id,
      "name": name,
      "gender": gender,
      "birth_date": dob,
      "address": address,
      "country": country,
      "city": city,
      "postal_code": postalCode,
      "phone": phone
    };

    print(body);
    try {
      var caller = await MyClient.post(
          endpoint: "/user/shipping/update", bodyData: body);

      commonResponse = CommonResponse.fromJson(jsonDecode(caller.body));

      if (commonResponse!.result) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> postDefaultAddress(
      {required String addressId, required int index}) async {
    try {
      var caller = await MyClient.post(
          endpoint: "/user/shipping/make_default",
          bodyData: {"user_id": userId, "id": addressId.toString()});

      commonResponse = CommonResponse.fromJson(jsonDecode(caller.body));
      if (commonResponse!.result) {
        return AppConstant.SUCCESS;
      } else {
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future<int> postAddressForDeletation(
      {required int addressId, required int index}) async {
    try {
      var caller = await MyClient.get(
          endpoint: "/user/shipping/delete/" + addressId.toString());
      commonResponse = CommonResponse.fromJson(jsonDecode(caller.body));

      if (commonResponse!.result) {
        dataHolder = null;
        return AppConstant.SUCCESS;
      } else {
        dataModel.add(dataHolder);
        notifyListeners();
        return AppConstant.FAILED;
      }
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future postToGetShippingCost(
      {required String ownerId, required String cityName}) async {
    try {
      var caller = await MyClient.post(
        endpoint: "/shipping_cost",
        bodyData: {
          "owner_id": ownerId,
          "user_id": userId,
          "city_name": cityName
        },
      );
      print(caller.body);
      var response = ShippingCostResponse.fromJson(jsonDecode(caller.body));

      if (response.result!) {
        shippingCostString = response.valueString.toString();
        shippingCost = response.value;
      } else {
        shippingCostString = response.value;
      }
      notifyListeners();
    } catch (e) {
      return AppConstant.SocketException;
    }
  }

  Future updateAddressForDelivery({required int addressId}) async {
    if (!loaderController.paymentLoader.value) {
      try {
        loaderController.paymentLoader.value = true;
        var body = {"address_id": addressId.toString(), "user_id": userId};
        var caller = await MyClient.post(
          endpoint: "/update-address-in-cart",
          bodyData: body,
        );

        var response = CommonResponse.fromJson(jsonDecode(caller.body));
        loaderController.paymentLoader.value = false;
        print(response.toJson());
      } catch (e) {
        loaderController.paymentLoader.value = false;
      }
    }
  }

  void caseHandler(int value) {
    List message = [
      commonResponse!.message.toString(),
      commonResponse!.message.toString(),
      "Network Error!!!!"
    ];
    Toast.createToast(
        context: context,
        message: message[value],
        duration: Duration(seconds: 1));
  }

  @override
  // ignore: must_call_super
  void dispose() {
    print("Address Provider disposed");
  }
}
