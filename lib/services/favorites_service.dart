import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_products';

  Future<List<int>> getFavoriteProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      return decoded.cast<int>();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isFavorite(int productId) async {
    final favorites = await getFavoriteProductIds();
    return favorites.contains(productId);
  }

  Future<void> addToFavorites(int productId) async {
    final favorites = await getFavoriteProductIds();
    if (!favorites.contains(productId)) {
      favorites.add(productId);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    final favorites = await getFavoriteProductIds();
    favorites.remove(productId);
    await _saveFavorites(favorites);
  }

  Future<void> toggleFavorite(int productId) async {
    final isFav = await isFavorite(productId);
    if (isFav) {
      await removeFromFavorites(productId);
    } else {
      await addToFavorites(productId);
    }
  }

  Future<List<Product>> getFavoriteProducts(List<Product> allProducts) async {
    final favoriteIds = await getFavoriteProductIds();
    return allProducts.where((product) {
      return product.id != null && favoriteIds.contains(product.id);
    }).toList();
  }

  Future<void> _saveFavorites(List<int> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, jsonEncode(favorites));
  }
}

