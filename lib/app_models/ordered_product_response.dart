class OrderedProductResponse {
  List<Data>? data;
  bool? success;
  int? status;

  OrderedProductResponse({this.data, this.success, this.status});

  OrderedProductResponse.fromJson(Map<String, dynamic> json) {
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
  int? productId;
  String? productName;
  String? variation;
  String? price;
  String? tax;
  String? shippingCost;
  String? couponDiscount;
  int? quantity;
  String? paymentStatus;
  String? paymentStatusString;
  String? deliveryStatus;
  String? deliveryStatusString;

  Data(
      {this.productId,
      this.productName,
      this.variation,
      this.price,
      this.tax,
      this.shippingCost,
      this.couponDiscount,
      this.quantity,
      this.paymentStatus,
      this.paymentStatusString,
      this.deliveryStatus,
      this.deliveryStatusString});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    variation = json['variation'];
    price = json['price'];
    tax = json['tax'];
    shippingCost = json['shipping_cost'];
    couponDiscount = json['coupon_discount'];
    quantity = json['quantity'];
    paymentStatus = json['payment_status'];
    paymentStatusString = json['payment_status_string'];
    deliveryStatus = json['delivery_status'];
    deliveryStatusString = json['delivery_status_string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['variation'] = this.variation;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['shipping_cost'] = this.shippingCost;
    data['coupon_discount'] = this.couponDiscount;
    data['quantity'] = this.quantity;
    data['payment_status'] = this.paymentStatus;
    data['payment_status_string'] = this.paymentStatusString;
    data['delivery_status'] = this.deliveryStatus;
    data['delivery_status_string'] = this.deliveryStatusString;
    return data;
  }
}
