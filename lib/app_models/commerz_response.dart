class CommerzResponse {
  bool? result;
  String? url;
  String? message;

  CommerzResponse({this.result, this.url, this.message});

  CommerzResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    url = json['url'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['url'] = this.url;
    data['message'] = this.message;
    return data;
  }
}
