import '../models/product.dart';
import '../models/product_category.dart';
import '../models/advertisement.dart';
import '../models/cart.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock Categories
  List<ProductCategory> getMockCategories() {
    return [
      ProductCategory(id: 1, name: 'Men'),
      ProductCategory(id: 2, name: 'Women'),
      ProductCategory(id: 3, name: 'Children'),
      ProductCategory(id: 4, name: 'Accessories'),
    ];
  }

  // Mock Products
  List<Product> getMockProducts() {
    final categories = getMockCategories();
    return [
      Product(
        id: 1,
        title: 'Classic Black Suit',
        description: 'Elegant black suit perfect for formal occasions. Made from premium wool blend with impeccable tailoring.',
        category: categories[0],
        price: '299.99',
        image: 'https://images.unsplash.com/photo-1594938291221-94f18e0e43b3?w=400',
      ),
      Product(
        id: 2,
        title: 'Navy Blue Blazer',
        description: 'Versatile navy blazer that pairs well with any outfit. Classic design with modern fit.',
        category: categories[0],
        price: '249.99',
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      ),
      Product(
        id: 3,
        title: 'Elegant Evening Dress',
        description: 'Stunning evening dress for special occasions. Flowing silhouette with elegant details.',
        category: categories[1],
        price: '349.99',
        image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
      ),
      Product(
        id: 4,
        title: 'Business Casual Shirt',
        description: 'Comfortable and professional shirt for everyday wear. Wrinkle-resistant fabric.',
        category: categories[0],
        price: '79.99',
        image: 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400',
      ),
      Product(
        id: 5,
        title: 'Designer Handbag',
        description: 'Luxury handbag with premium leather. Perfect for both casual and formal occasions.',
        category: categories[3],
        price: '199.99',
        image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
      ),
      Product(
        id: 6,
        title: 'Kids Formal Suit',
        description: 'Adorable formal suit for children. Comfortable fit with classic styling.',
        category: categories[2],
        price: '129.99',
        image: 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400',
      ),
      Product(
        id: 7,
        title: 'Silk Scarf',
        description: 'Premium silk scarf with elegant patterns. Adds sophistication to any outfit.',
        category: categories[3],
        price: '49.99',
        image: 'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=400',
      ),
      Product(
        id: 8,
        title: 'Leather Belt',
        description: 'Genuine leather belt with classic buckle. Durable and stylish accessory.',
        category: categories[3],
        price: '39.99',
        image: 'https://images.unsplash.com/photo-1624222247344-550fb60583fd?w=400',
      ),
    ];
  }

  // Mock Advertisements
  List<Advertisement> getMockAdvertisements() {
    return [
      Advertisement(
        id: 1,
        title: 'New Collection 2024',
        description: 'Discover our latest fashion collection with exclusive designs',
        image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
        createdAt: DateTime.now().toIso8601String(),
      ),
      Advertisement(
        id: 2,
        title: 'Summer Sale',
        description: 'Up to 50% off on selected items',
        image: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400',
        createdAt: DateTime.now().toIso8601String(),
      ),
      Advertisement(
        id: 3,
        title: 'Premium Quality',
        description: 'Experience luxury with our premium collection',
        image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400',
        createdAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  // Mock Cart Items (for demonstration)
  List<Cart> getMockCartItems() {
    final products = getMockProducts();
    return [
      Cart(
        id: 1,
        product: products[0],
        productId: products[0].id!,
        quantity: 1,
        totalPrice: '299.99',
      ),
      Cart(
        id: 2,
        product: products[2],
        productId: products[2].id!,
        quantity: 2,
        totalPrice: '699.98',
      ),
    ];
  }

  // Get product by ID from mock data
  Product? getProductById(int id) {
    final products = getMockProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter products by category
  List<Product> getProductsByCategory(int? categoryId) {
    if (categoryId == null) return getMockProducts();
    return getMockProducts().where((p) => p.category?.id == categoryId).toList();
  }

  // Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return getMockProducts();
    final lowerQuery = query.toLowerCase();
    return getMockProducts().where((p) {
      return p.title.toLowerCase().contains(lowerQuery) ||
          p.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

