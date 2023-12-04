class RegisterResponse {
  bool? result;
  String? message;
  int? userId;

  RegisterResponse({this.result, this.message, this.userId});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    return data;
  }
}
