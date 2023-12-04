class FilterProductResponse {
  List<Data>? data;
  Pagelinks? pagelinks;
  Meta? meta;
  bool? success;
  int? status;

  FilterProductResponse(
      {this.data, this.pagelinks, this.meta, this.success, this.status});

  FilterProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagelinks = json['Pagelinks'] != null
        ? new Pagelinks.fromJson(json['Pagelinks'])
        : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagelinks != null) {
      data['Pagelinks'] = this.pagelinks!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
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
  double? discount;
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
    discount = double.parse(json['discount'].toString());
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

class Pagelinks {
  String? first;
  String? last;
  String? prev;
  String? next;

  Pagelinks({this.first, this.last, this.prev, this.next});

  Pagelinks.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  late int lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      required this.lastPage,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}
