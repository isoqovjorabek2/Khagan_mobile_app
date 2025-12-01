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
    // Handle product_id - can be in json['product_id'] or json['product']['id']
    int productId;
    if (json['product_id'] != null) {
      productId = json['product_id'] is int 
          ? json['product_id'] 
          : int.tryParse(json['product_id'].toString()) ?? 0;
    } else if (json['product'] != null && json['product']['id'] != null) {
      productId = json['product']['id'] is int
          ? json['product']['id']
          : int.tryParse(json['product']['id'].toString()) ?? 0;
    } else {
      productId = 0;
    }

    // Handle total_price - can be string or number
    String? totalPriceStr;
    if (json['total_price'] != null) {
      if (json['total_price'] is String) {
        totalPriceStr = json['total_price'];
      } else if (json['total_price'] is num) {
        totalPriceStr = json['total_price'].toString();
      }
    }

    return Cart(
      id: json['id'],
      product: Product.fromJson(json['product']),
      productId: productId,
      quantity: json['quantity'] is int ? json['quantity'] : (json['quantity'] ?? 1),
      totalPrice: totalPriceStr,
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

