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
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      price: json['price'],
      image: json['image'],
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

