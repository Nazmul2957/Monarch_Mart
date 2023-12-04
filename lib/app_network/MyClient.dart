import 'dart:convert';

import 'package:http/http.dart' as client;
import 'package:monarch_mart/app_components/app_constant.dart';
import 'package:monarch_mart/app_components/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyClient {
  static Future<client.Response> get(
      {required String endpoint, Map<String, dynamic>? queryParameters}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(AppConstant.ACCESS_TOKEN) ?? "";
    Uri uri = Uri.parse(AppUrl.base_url +
        endpoint +
        (queryParameters != null ? _formatParams(queryParameters) : ""));
    print(uri);
    return client.get(
      uri,
      headers: {
        "Authorization": "Bearer " + accessToken,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
  }

  static Future<client.Response> post(
      {required String endpoint,
      required Map<String, dynamic> bodyData}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(AppConstant.ACCESS_TOKEN) ?? "";
    var uri = Uri.parse(AppUrl.base_url + endpoint);
    print(uri);
    var headers = {
      "Authorization": "Bearer " + accessToken,
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    print(headers);
    return client.post(uri, body: jsonEncode(bodyData), headers: headers);
  }

  static Future<client.Response> delete({
    required String endpoint,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(AppConstant.ACCESS_TOKEN) ?? "";
    var uri = Uri.parse(AppUrl.base_url + endpoint);
    print(uri);
    return client.delete(uri, headers: {
      "Authorization": "Bearer " + accessToken,
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
  }

  static String _formatParams(Map<String, dynamic> queryparams) {
    String parameters = "";
    queryparams.entries.forEach((element) {
      parameters = parameters +
          "&" +
          element.key.toString() +
          "=" +
          element.value.toString();
    });

    return "?" + parameters;
  }
}
