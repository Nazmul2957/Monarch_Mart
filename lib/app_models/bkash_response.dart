class BkashResponse {
  String? token;
  bool? result;
  String? url;
  String? message;

  BkashResponse({this.token, this.result, this.url, this.message});

  BkashResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    result = json['result'];
    url = json['url'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['result'] = this.result;
    data['url'] = this.url;
    data['message'] = this.message;
    return data;
  }
}
