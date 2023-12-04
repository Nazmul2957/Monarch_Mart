class VariantResponse {
  int? productId;
  String? variant;
  int? price;
  String? priceString;
  String? sku;
  int? stock;

  VariantResponse(
      {this.productId,
      this.variant,
      this.price,
      this.priceString,
      this.sku,
      this.stock});

  VariantResponse.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    variant = json['variant'];
    price = json['price'];
    priceString = json['price_string'];
    sku = json['sku'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['variant'] = this.variant;
    data['price'] = this.price;
    data['price_string'] = this.priceString;
    data['sku'] = this.sku;
    data['stock'] = this.stock;
    return data;
  }
}
