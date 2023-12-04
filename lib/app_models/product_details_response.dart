import 'package:monarch_mart/app_models/product_response.dart';

class ProductDetailsResponse {
  List<Data>? data;
  bool? success;
  int? status;

  ProductDetailsResponse({this.data, this.success, this.status});

  ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  String? addedBy;
  int? sellerId;
  int? shopId;
  String? shopName;
  String? shopLogo;
  List<Photos>? photos;
  String? thumbnailImage;
  List<String>? tags;
  String? priceHighLow;
  List<ChoiceOptions>? choiceOptions;
  bool? hasDiscount;
  int? discountPercent;
  double? discount;
  String? baseSku;
  String? discountType;
  String? strokedPrice;
  String? mainPrice;
  int? calculablePrice;
  String? currencySymbol;
  int? currentStock;
  String? unit;
  dynamic rating;
  dynamic ratingCount;
  dynamic earnPoint;
  String? description;
  String? videoLink;
  String? videoProvide;
  String? productLink;
  String? disclaimer;
  String? brand;
  String? onClickBrand;
  ProductResponse? relatedProducts;

  Data({
    this.id,
    this.name,
    this.addedBy,
    this.sellerId,
    this.shopId,
    this.shopName,
    this.shopLogo,
    this.photos,
    this.thumbnailImage,
    this.tags,
    this.priceHighLow,
    this.choiceOptions,
    this.hasDiscount,
    this.discountPercent,
    this.brand,
    this.onClickBrand,
    this.discount,
    this.discountType,
    this.strokedPrice,
    this.mainPrice,
    this.calculablePrice,
    this.currencySymbol,
    this.currentStock,
    this.baseSku,
    this.unit,
    this.rating,
    this.ratingCount,
    this.earnPoint,
    this.description,
    this.productLink,
    this.videoLink,
    this.videoProvide,
    this.disclaimer,
    this.relatedProducts,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addedBy = json['added_by'];
    sellerId = json['seller_id'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopLogo = json['shop_logo'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
    thumbnailImage = json['thumbnail_image'];
    tags = json['tags'].cast<String>();
    priceHighLow = json['price_high_low'];
    if (json['choice_options'] != null) {
      choiceOptions = <ChoiceOptions>[];
      json['choice_options'].forEach((v) {
        choiceOptions!.add(new ChoiceOptions.fromJson(v));
      });
    }
    brand = json['brand'];
    onClickBrand = json['on_click_brand'];
    hasDiscount = json['has_discount'];
    discountPercent = json['discount_percent'];
    discount = json['discount'] != null
        ? double.parse(json['discount'].toString())
        : json['discount'];
    discountType = json['discount_type'];
    strokedPrice = json['stroked_price'];
    mainPrice = json['main_price'];
    calculablePrice = json['calculable_price'];
    currencySymbol = json['currency_symbol'];
    currentStock = json['current_stock'];
    baseSku = json['base_sku'];
    unit = json['unit'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    earnPoint = json['earn_point'];
    description = json['description'];
    productLink = json['product_link'];
    videoLink = json['video_link'];
    videoProvide = json['video_provide'];
    disclaimer = json['disclaimer'];
    relatedProducts = json['related_products'] != null
        ? new ProductResponse.fromJson(json['related_products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['added_by'] = this.addedBy;
    data['seller_id'] = this.sellerId;
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_logo'] = this.shopLogo;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['thumbnail_image'] = this.thumbnailImage;
    data['tags'] = this.tags;
    data['price_high_low'] = this.priceHighLow;
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['brand'] = this.brand;
    data['on_click_brand'] = this.onClickBrand;
    data['has_discount'] = this.hasDiscount;
    data['discount_percent'] = this.discountPercent;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['stroked_price'] = this.strokedPrice;
    data['main_price'] = this.mainPrice;
    data['calculable_price'] = this.calculablePrice;
    data['currency_symbol'] = this.currencySymbol;
    data['current_stock'] = this.currentStock;
    data['base_sku'] = this.baseSku;
    data['unit'] = this.unit;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['earn_point'] = this.earnPoint;
    data['description'] = this.description;
    data['product_link'] = this.productLink;
    data['video_link'] = this.videoLink;
    data['video_provide'] = this.videoProvide;
    data['disclaimer'] = this.disclaimer;
    if (this.relatedProducts != null) {
      data['related_products'] = this.relatedProducts!.toJson();
    }
    return data;
  }
}

class Photos {
  String? variant;
  String? path;

  Photos({this.variant, this.path});

  Photos.fromJson(Map<String, dynamic> json) {
    variant = json['variant'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant'] = this.variant;
    data['path'] = this.path;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['options'] = this.options;
    return data;
  }
}
