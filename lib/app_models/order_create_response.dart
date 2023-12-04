class OrderCreateResponse {
  late int combinedOrderId;
  late bool result;
  late String message;

  OrderCreateResponse(
      {required this.combinedOrderId,
      required this.result,
      required this.message});

  OrderCreateResponse.fromJson(Map<String, dynamic> json) {
    combinedOrderId = json['combined_order_id'];
    result = json['result'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['combined_order_id'] = this.combinedOrderId;
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}
