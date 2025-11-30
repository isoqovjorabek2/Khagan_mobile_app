import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'CategoryPage.dart';
import '../../services/product_service.dart';
import '../../models/product.dart';
import '../../models/advertisement.dart';
import 'ProductDetailsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Advertisement> _advertisements = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productService.getProducts();
      final ads = await _productService.getAdvertisements();
      setState(() {
        _products = products;
        _advertisements = ads;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      _loadData();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final products = await _productService.getProducts(search: query);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hi 👋",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _searchProducts,
                              decoration: const InputDecoration(
                                hintText: "Search",
                                prefixIcon: Icon(LucideIcons.search),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.slidersHorizontal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Trending Banner
                    _buildBannerSection(),

                    const SizedBox(height: 24),

                    // Category Section
                    _buildCategorySection(context),

                    const SizedBox(height: 20),

                    // Product Grid
                    _products.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text('No products found',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return _buildProductCard(product);
                            },
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  // --- UI components ---
  Widget _buildBannerSection() {
    if (_advertisements.isEmpty) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://via.placeholder.com/400x300?text=TRENDING'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Shop Now",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                _smallImage('https://via.placeholder.com/150x150?text=Model'),
                const SizedBox(height: 10),
                _smallImage('https://via.placeholder.com/150x150?text=8+'),
              ],
            ),
          ),
        ],
      );
    }

    final ad = _advertisements.first;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              image: ad.image != null
                  ? DecorationImage(
                      image: NetworkImage(ad.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Shop Now",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              if (_advertisements.length > 1)
                _smallImage(_advertisements[1].image ??
                    'https://via.placeholder.com/150x150'),
              const SizedBox(height: 10),
              if (_advertisements.length > 2)
                _smallImage(_advertisements[2].image ??
                    'https://via.placeholder.com/150x150'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _smallImage(String url) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {}),
      ),
    );
  }

  // ✅ Category Section (with See All)
  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "New For Men",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 350),
                    pageBuilder: (_, __, ___) => const CategoryPage(),
                    transitionsBuilder: (_, animation, __, child) =>
                        SlideTransition(
                      position: Tween(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );
              },
              child: const Text(
                "See all",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _chip("All", true),
              _chip("Women", false),
              _chip("Men", false),
              _chip("Children", false),
              _chip("Kids", false),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _chip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.orangeAccent : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(productId: product.id!),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: product.image != null
                  ? Image.network(product.image!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                            height: 160,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ))
                  : Container(
                      height: 160,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price != null ? '\$${product.price}' : '\$0.00',
                        style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.black, size: 14),
                          SizedBox(width: 4),
                          Text('4.5',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

