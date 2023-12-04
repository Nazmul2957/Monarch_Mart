class ProfileImageUpdateresponse {
  late bool result;
  String? message;
  String? path;

  ProfileImageUpdateresponse({required this.result, this.message, this.path});

  ProfileImageUpdateresponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['path'] = this.path;
    return data;
  }
}
