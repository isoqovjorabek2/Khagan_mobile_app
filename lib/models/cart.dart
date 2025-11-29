import 'product.dart';

class Cart {
  final int? id;
  final Product product;
  final int productId;
  final int quantity;
  final String? totalPrice;

  Cart({
    this.id,
    required this.product,
    required this.productId,
    required this.quantity,
    this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      product: Product.fromJson(json['product']),
      productId: json['product_id'] ?? json['product']['id'],
      quantity: json['quantity'] ?? 1,
      totalPrice: json['total_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'product_id': productId,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}

