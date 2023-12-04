class CheckoutSummaryResponse {
  var subTotal;
  var tax;
  var shippingCost;
  var discount;
  var grandTotal;
  var grandTotalValue;
  String? couponCode;
  bool? couponApplied;

  CheckoutSummaryResponse(
      {this.subTotal,
      this.tax,
      this.shippingCost,
      this.discount,
      this.grandTotal,
      this.grandTotalValue,
      this.couponCode,
      this.couponApplied});

  CheckoutSummaryResponse.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
    tax = json['tax'];
    shippingCost = json['shipping_cost'];
    discount = json['discount'];
    grandTotal = json['grand_total'];
    grandTotalValue = json['grand_total_value'];
    couponCode = json['coupon_code'];
    couponApplied = json['coupon_applied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_total'] = this.subTotal;
    data['tax'] = this.tax;
    data['shipping_cost'] = this.shippingCost;
    data['discount'] = this.discount;
    data['grand_total'] = this.grandTotal;
    data['grand_total_value'] = this.grandTotalValue;
    data['coupon_code'] = this.couponCode;
    data['coupon_applied'] = this.couponApplied;
    return data;
  }
}
