import 'dart:convert';
import '../config/api_config.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/advertisement.dart';
import 'api_client.dart';
import 'mock_data_service.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();
  final MockDataService _mockDataService = MockDataService();

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
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        // Authentication failed, use mock data as fallback
        return _mockDataService.getMockCategories();
      } else {
        throw Exception('Failed to get categories: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // On any error, try to return mock data as fallback
      try {
        return _mockDataService.getMockCategories();
      } catch (_) {
        throw Exception('Get categories error: $e');
      }
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
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        // Authentication failed, use mock data as fallback
        return _mockDataService.getMockProducts();
      } else {
        throw Exception('Failed to get products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // On any error, try to return mock data as fallback
      try {
        return _mockDataService.getMockProducts();
      } catch (_) {
        throw Exception('Get products error: $e');
      }
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
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        // Authentication failed, try to find in mock data
        final mockProducts = _mockDataService.getMockProducts();
        final product = mockProducts.firstWhere(
          (p) => p.id == id,
          orElse: () => throw Exception('Product not found'),
        );
        return product;
      } else {
        throw Exception('Failed to get product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // On any error, try to return mock data as fallback
      try {
        final mockProducts = _mockDataService.getMockProducts();
        final product = mockProducts.firstWhere(
          (p) => p.id == id,
          orElse: () => throw Exception('Product not found'),
        );
        return product;
      } catch (_) {
        throw Exception('Get product error: $e');
      }
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
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        // Authentication failed, use mock data as fallback
        return _mockDataService.getMockAdvertisements();
      } else {
        throw Exception('Failed to get advertisements: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // On any error, try to return mock data as fallback
      try {
        return _mockDataService.getMockAdvertisements();
      } catch (_) {
        throw Exception('Get advertisements error: $e');
      }
    }
  }
}

