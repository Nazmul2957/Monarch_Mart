// To parse this JSON data, do
//
//     final mAuth = mAuthFromJson(jsonString);

import 'dart:convert';

MToken mTokenFromJson(String str) => MToken.fromJson(json.decode(str));

String mTokenToJson(MToken data) => json.encode(data.toJson());

class MToken {
  MToken({
    this.id,
    this.token,
    this.modifiedAt,
    this.userName,
  });

  String? id;
  String? token;
  String? userName;
  DateTime? modifiedAt;

  factory MToken.fromJson(Map<String, dynamic> json) => MToken(
        id: json["id"],
        userName: json["user_name"],
        token: json["token"],
        modifiedAt: DateTime.parse(json["modified_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "token": token,
        "modified_at": modifiedAt,
      };
}
