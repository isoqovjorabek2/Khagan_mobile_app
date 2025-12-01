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
        // Return mock data if backend returns empty
        if (categories.isEmpty) {
          return _mockDataService.getMockCategories();
        }
        return categories;
      } else {
        // Fallback to mock data on error
        return _mockDataService.getMockCategories();
      }
    } catch (e) {
      // Fallback to mock data on network error
      return _mockDataService.getMockCategories();
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
        List<Product> products = [];
        if (data is List) {
          products = data.map((item) => Product.fromJson(item)).toList();
        } else if (data['results'] != null) {
          products = (data['results'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
        }
        // Return mock data if backend returns empty
        if (products.isEmpty) {
          if (search != null && search.isNotEmpty) {
            return _mockDataService.searchProducts(search);
          } else if (categoryId != null) {
            return _mockDataService.getProductsByCategory(categoryId);
          }
          return _mockDataService.getMockProducts();
        }
        return products;
      } else {
        // Fallback to mock data on error
        if (search != null && search.isNotEmpty) {
          return _mockDataService.searchProducts(search);
        } else if (categoryId != null) {
          return _mockDataService.getProductsByCategory(categoryId);
        }
        return _mockDataService.getMockProducts();
      }
    } catch (e) {
      // Fallback to mock data on network error
      if (search != null && search.isNotEmpty) {
        return _mockDataService.searchProducts(search);
      } else if (categoryId != null) {
        return _mockDataService.getProductsByCategory(categoryId);
      }
      return _mockDataService.getMockProducts();
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
        // Fallback to mock data
        final mockProduct = _mockDataService.getProductById(id);
        if (mockProduct != null) {
          return mockProduct;
        }
        throw Exception('Failed to get product: ${response.body}');
      }
    } catch (e) {
      // Fallback to mock data on error
      final mockProduct = _mockDataService.getProductById(id);
      if (mockProduct != null) {
        return mockProduct;
      }
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
        List<Advertisement> ads = [];
        if (data is List) {
          ads = data.map((item) => Advertisement.fromJson(item)).toList();
        } else if (data['results'] != null) {
          ads = (data['results'] as List)
              .map((item) => Advertisement.fromJson(item))
              .toList();
        }
        // Return mock data if backend returns empty
        if (ads.isEmpty) {
          return _mockDataService.getMockAdvertisements();
        }
        return ads;
      } else {
        // Fallback to mock data on error
        return _mockDataService.getMockAdvertisements();
      }
    } catch (e) {
      // Fallback to mock data on network error
      return _mockDataService.getMockAdvertisements();
    }
  }
}

