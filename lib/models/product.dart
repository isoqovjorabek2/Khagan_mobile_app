import 'product_category.dart';

class Product {
  final int? id;
  final String title;
  final String description;
  final ProductCategory? category;
  final String? price;
  final String? image;

  Product({
    this.id,
    required this.title,
    required this.description,
    this.category,
    this.price,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle price as both string and number
    String? priceStr;
    if (json['price'] != null) {
      if (json['price'] is String) {
        priceStr = json['price'];
      } else if (json['price'] is num) {
        priceStr = json['price'].toString();
      }
    }

    // Handle image URL - convert relative path to full URL if needed
    String? imageUrl;
    if (json['image'] != null) {
      final image = json['image'].toString();
      if (image.startsWith('http://') || image.startsWith('https://')) {
        // Ensure we use https://
        imageUrl = image.replaceFirst('http://', 'https://');
      } else if (image.isNotEmpty) {
        // If it's a relative path, prepend base URL with https://
        imageUrl = 'https://khagan.univibe.uz$image';
      }
    }

    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      price: priceStr,
      image: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category?.toJson(),
      'price': price,
      'image': image,
    };
  }
}

