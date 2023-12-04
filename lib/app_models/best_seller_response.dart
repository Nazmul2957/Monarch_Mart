class BestSellerResponse {
  List<Data>? data;
  bool? success;
  int? status;

  BestSellerResponse({this.data, this.success, this.status});

  BestSellerResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? photo;
  double? rating;
  String? url;

  Data({this.photo, this.rating, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    rating = double.parse(json['rating'].toString());
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['rating'] = this.rating;
    data['url'] = this.url;
    return data;
  }
}
