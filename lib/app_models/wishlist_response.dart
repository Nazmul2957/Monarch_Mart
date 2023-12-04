class WishlistResponse {
  String? message;
  late bool isInWishlist;
  int? productId;
  int? wishlistId;

  WishlistResponse(
      {this.message,
      required this.isInWishlist,
      this.productId,
      this.wishlistId});

  WishlistResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isInWishlist = json['is_in_wishlist'];
    productId = json['product_id'];
    wishlistId = json['wishlist_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['is_in_wishlist'] = this.isInWishlist;
    data['product_id'] = this.productId;
    data['wishlist_id'] = this.wishlistId;
    return data;
  }
}
