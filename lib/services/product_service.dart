import 'dart:convert';
import '../config/api_config.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/advertisement.dart';
import 'api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.categoriesEndpoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<ProductCategory> categories = [];
        if (data is List) {
          categories = data.map((item) => ProductCategory.fromJson(item)).toList();
        } else if (data['results'] != null) {
          categories = (data['results'] as List)
              .map((item) => ProductCategory.fromJson(item))
              .toList();
        }
        return categories;
      } else {
        throw Exception('Failed to get categories: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get categories error: $e');
    }
  }

  Future<List<Product>> getProducts({
    int? categoryId,
    String? search,
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId.toString();
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }
      if (pageSize != null) {
        queryParams['page_size'] = pageSize.toString();
      }

      final response = await _apiClient.get(
        ApiConfig.productsEndpoint,
        queryParams: queryParams,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Product> products = [];
        if (data is List) {
          products = data.map((item) => Product.fromJson(item)).toList();
        } else if (data['results'] != null) {
          products = (data['results'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
        }
        return products;
      } else {
        throw Exception('Failed to get products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get products error: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.productDetailEndpoint}$id/',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to get product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get product error: $e');
    }
  }

  Future<List<Advertisement>> getAdvertisements() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.adsEndpoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Advertisement> ads = [];
        if (data is List) {
          ads = data.map((item) => Advertisement.fromJson(item)).toList();
        } else if (data['results'] != null) {
          ads = (data['results'] as List)
              .map((item) => Advertisement.fromJson(item))
              .toList();
        }
        return ads;
      } else {
        throw Exception('Failed to get advertisements: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get advertisements error: $e');
    }
  }
}

