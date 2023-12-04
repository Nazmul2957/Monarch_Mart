class Payload {
  String? image;
  String? type;
  String? clickAction;

  Payload({this.image, this.type, this.clickAction});

  Payload.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    type = json['type'];
    clickAction = json['click_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['type'] = this.type;
    data['click_action'] = this.clickAction;
    return data;
  }
}
