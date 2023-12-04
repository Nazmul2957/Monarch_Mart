class OrderDetailsResponse {
  List<Data>? data;
  bool? success;
  int? status;

  OrderDetailsResponse({this.data, this.success, this.status});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
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
  String? code;
  int? userId;
  ShippingAddress? shippingAddress;
  String? paymentType;
  String? shippingType;
  String? shippingTypeString;
  String? paymentStatus;
  String? paymentStatusString;
  String? deliveryStatus;
  String? deliveryStatusString;
  String? grandTotal;
  String? couponDiscount;
  String? shippingCost;
  String? subtotal;
  String? tax;
  String? date;
  bool? cancelRequest;
  Links? links;

  Data(
      {this.id,
      this.code,
      this.userId,
      this.shippingAddress,
      this.paymentType,
      this.shippingType,
      this.shippingTypeString,
      this.paymentStatus,
      this.paymentStatusString,
      this.deliveryStatus,
      this.deliveryStatusString,
      this.grandTotal,
      this.couponDiscount,
      this.shippingCost,
      this.subtotal,
      this.tax,
      this.date,
      this.cancelRequest,
      this.links});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    paymentType = json['payment_type'];
    shippingType = json['shipping_type'];
    shippingTypeString = json['shipping_type_string'];
    paymentStatus = json['payment_status'];
    paymentStatusString = json['payment_status_string'];
    deliveryStatus = json['delivery_status'];
    deliveryStatusString = json['delivery_status_string'];
    grandTotal = json['grand_total'];
    couponDiscount = json['coupon_discount'];
    shippingCost = json['shipping_cost'];
    subtotal = json['subtotal'];
    tax = json['tax'];
    date = json['date'];
    cancelRequest = json['cancel_request'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['user_id'] = this.userId;
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    data['payment_type'] = this.paymentType;
    data['shipping_type'] = this.shippingType;
    data['shipping_type_string'] = this.shippingTypeString;
    data['payment_status'] = this.paymentStatus;
    data['payment_status_string'] = this.paymentStatusString;
    data['delivery_status'] = this.deliveryStatus;
    data['delivery_status_string'] = this.deliveryStatusString;
    data['grand_total'] = this.grandTotal;
    data['coupon_discount'] = this.couponDiscount;
    data['shipping_cost'] = this.shippingCost;
    data['subtotal'] = this.subtotal;
    data['tax'] = this.tax;
    data['date'] = this.date;
    data['cancel_request'] = this.cancelRequest;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    return data;
  }
}

class ShippingAddress {
  int? id;
  String? userId;
  String? address;
  String? country;
  String? city;
  String? postalCode;
  String? phone;
  String? setDefault;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? email;

  ShippingAddress(
      {this.id,
      this.userId,
      this.address,
      this.country,
      this.city,
      this.postalCode,
      this.phone,
      this.setDefault,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.email});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    setDefault = json['set_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['set_default'] = this.setDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['email'] = this.email;
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
