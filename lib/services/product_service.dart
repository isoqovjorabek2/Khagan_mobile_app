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
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => ProductCategory.fromJson(item)).toList();
        } else if (data['results'] != null) {
          return (data['results'] as List)
              .map((item) => ProductCategory.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to get categories: ${response.body}');
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
        queryParams['category'] = categoryId.toString();
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
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Product.fromJson(item)).toList();
        } else if (data['results'] != null) {
          return (data['results'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to get products: ${response.body}');
      }
    } catch (e) {
      throw Exception('Get products error: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.productDetailEndpoint}$id/',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to get product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Get product error: $e');
    }
  }

  Future<List<Advertisement>> getAdvertisements() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.adsEndpoint,
        requiresAuth: false,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Advertisement.fromJson(item)).toList();
        } else if (data['results'] != null) {
          return (data['results'] as List)
              .map((item) => Advertisement.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to get advertisements: ${response.body}');
      }
    } catch (e) {
      throw Exception('Get advertisements error: $e');
    }
  }
}

