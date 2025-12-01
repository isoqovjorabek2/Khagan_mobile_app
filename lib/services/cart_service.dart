import 'dart:convert';
import '../config/api_config.dart';
import '../models/cart.dart';
import '../models/card.dart';
import 'api_client.dart';
import 'mock_data_service.dart';

class CartService {
  final ApiClient _apiClient = ApiClient();
  final MockDataService _mockDataService = MockDataService();

  Future<List<Cart>> getCart() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.getCartEndpoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Cart> cartItems = [];
        if (data is List) {
          cartItems = data.map((item) => Cart.fromJson(item)).toList();
        } else if (data['results'] != null) {
          cartItems = (data['results'] as List)
              .map((item) => Cart.fromJson(item))
              .toList();
        } else if (data['items'] != null) {
          cartItems = (data['items'] as List)
              .map((item) => Cart.fromJson(item))
              .toList();
        }
        // Return empty cart if backend returns empty (not mock data for cart)
        return cartItems;
      } else {
        // Return empty cart on error (cart requires auth, so don't show mock data)
        return [];
      }
    } catch (e) {
      // Return empty cart on network error
      // Note: We don't return mock cart data as cart is user-specific
      return [];
    }
  }

  Future<Cart> addProductToCart(int productId, {int quantity = 1}) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.addProductToCartEndpoint,
        body: {
          'product_id': productId,
          'quantity': quantity,
        },
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Cart.fromJson(data);
      } else {
        throw Exception('Failed to add product to cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Add product to cart error: $e');
    }
  }

  Future<bool> deleteProductFromCart(int productId) async {
    try {
      final response = await _apiClient.delete(
        '${ApiConfig.deleteProductFromCartEndpoint}$productId/',
        requiresAuth: true,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Delete product from cart error: $e');
    }
  }

  Future<bool> orderCart() async {
    try {
      final response = await _apiClient.post(
        ApiConfig.orderCartEndpoint,
        requiresAuth: true,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Order cart error: $e');
    }
  }

  Future<List<Card>> getCards() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.listCardsEndpoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Card.fromJson(item)).toList();
        } else if (data['results'] != null) {
          return (data['results'] as List)
              .map((item) => Card.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to get cards: ${response.body}');
      }
    } catch (e) {
      throw Exception('Get cards error: $e');
    }
  }

  Future<Card> addCard({
    required String cardName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.addCardEndpoint,
        body: {
          'card_name': cardName,
          'card_number': cardNumber,
          'expiry_date': expiryDate,
          'cvv': cvv,
        },
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Card.fromJson(data);
      } else {
        throw Exception('Failed to add card: ${response.body}');
      }
    } catch (e) {
      throw Exception('Add card error: $e');
    }
  }
}

