import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../app_models/policy_response.dart';
import '../app_network/MyClient.dart';

class PolicyProvider extends ChangeNotifier {
  String? details = "";
  bool isInitialize = false;
  PolicyResponse? response;

  init({required String policyType}) {
    this.isInitialize = true;
    getDetails(policyType: policyType);
  }

  Future getDetails({required String policyType}) async {
    try {
      var caller = await MyClient.post(
          endpoint: "/page-content", bodyData: {"slug": policyType});

      response = PolicyResponse.fromJson(jsonDecode(caller.body));
      if (caller.statusCode == 200) {
        details = response?.content;
      }
    } catch (e) {}

    notifyListeners();
  }
}
