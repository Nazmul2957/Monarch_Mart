class SellerDetailsResponse {
  bool? success;
  int? status;
  List<Data>? data;

  SellerDetailsResponse({this.success, this.status, this.data});

  SellerDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? name;
  String? logo;
  List<String>? sliders;
  String? address;
  String? facebook;
  String? google;
  String? twitter;
  double? rating;
  double? trueRating;

  Data(
      {this.id,
      this.userId,
      this.name,
      this.logo,
      this.sliders,
      this.address,
      this.facebook,
      this.google,
      this.twitter,
      this.rating,
      this.trueRating});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    logo = json['logo'];
    sliders = json['sliders'].cast<String>();
    address = json['address'];
    facebook = json['facebook'];
    google = json['google'];
    twitter = json['twitter'];
    rating = json['rating'].toDouble();
    trueRating = json['true_rating'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['sliders'] = this.sliders;
    data['address'] = this.address;
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['twitter'] = this.twitter;
    data['rating'] = this.rating;
    data['true_rating'] = this.trueRating;
    return data;
  }
}
