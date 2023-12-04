class FeaturedProductResponse {
  List<Data>? data;
  bool? success;
  int? status;

  FeaturedProductResponse({this.data, this.success, this.status});

  FeaturedProductResponse.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? thumbnailImage;
  bool? hasDiscount;
  int? discount;
  String? discountType;
  String? currentPrice;
  String? basePrice;
  double? rating;
  int? sales;
  Links? links;

  Data(
      {this.id,
      this.name,
      this.thumbnailImage,
      this.hasDiscount,
      this.discount,
      this.discountType,
      this.currentPrice,
      this.basePrice,
      this.rating,
      this.sales,
      this.links});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailImage = json['thumbnail_image'];
    hasDiscount = json['has_discount'];
    discount = int.parse(json['discount'].toString());
    discountType = json['discount_type'];
    currentPrice = json['current_price'];
    basePrice = json['base_price'];
    rating = double.parse(json['rating'].toString());
    sales = json['sales'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnail_image'] = this.thumbnailImage;
    data['has_discount'] = this.hasDiscount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['current_price'] = this.currentPrice;
    data['base_price'] = this.basePrice;
    data['rating'] = this.rating;
    data['sales'] = this.sales;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    return data;
  }
}

class Links {
  String? details;

  Links({this.details});

  Links.fromJson(Map<String, dynamic> json) {
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['details'] = this.details;
    return data;
  }
}
