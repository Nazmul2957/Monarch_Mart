class CartModel {
  int? ownerId;
  String? title;
  List<Model>? itemsList;
  CartModel({this.ownerId, this.title, this.itemsList});
}

class Model {
  int? id;

  int? ownerId;
  int? userId;
  int? productId;
  String? productName;
  String? productThumbnailImage;
  String? variation;
  int? price;
  String? currencySymbol;
  int? tax;
  double? shippingCost;
  int? quantity;
  int? lowerLimit;
  int? upperLimit;

  Model(
      {this.id,
      this.ownerId,
      this.userId,
      this.productId,
      this.productName,
      this.productThumbnailImage,
      this.variation,
      this.price,
      this.currencySymbol,
      this.tax,
      this.shippingCost,
      this.quantity,
      this.lowerLimit,
      this.upperLimit});
}
