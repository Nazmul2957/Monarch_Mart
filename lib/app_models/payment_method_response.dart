class PaymentMethodResponse {
  String? paymentType;
  String? paymentTypeKey;
  String? image;
  String? name;
  String? title;

  PaymentMethodResponse(
      {this.paymentType,
      this.paymentTypeKey,
      this.image,
      this.name,
      this.title});

  PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    paymentType = json['payment_type'];
    paymentTypeKey = json['payment_type_key'];
    image = json['image'];
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_type'] = this.paymentType;
    data['payment_type_key'] = this.paymentTypeKey;
    data['image'] = this.image;
    data['name'] = this.name;
    data['title'] = this.title;
    return data;
  }
}
