class ShippingCostResponse {
  bool? result;
  String? shippingType;
  String? value;
  String? valueString;

  ShippingCostResponse(
      {this.result, this.shippingType, this.value, this.valueString});

  ShippingCostResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    shippingType = json['shipping_type'];
    value = json['value'].toString();
    valueString = json['value_string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['shipping_type'] = this.shippingType;
    data['value'] = this.value;
    data['value_string'] = this.valueString;
    return data;
  }
}
