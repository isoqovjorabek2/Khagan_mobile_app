import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'CategoryPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hi Dennis 👋",
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
                      child: const TextField(
                        decoration: InputDecoration(
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
              _buildCategorySection(context), // 👈 pass context here

              const SizedBox(height: 20),

              // Product Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _defaultProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final product = _defaultProducts[index];
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
  static Widget _buildBannerSection() {
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

  static Widget _smallImage(String url) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  // ✅ Category Section (with See All)
  static Widget _buildCategorySection(BuildContext context) {
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

  static Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
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
            child: Image.network(product['image'],
                height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product['price'],
                        style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.black, size: 14),
                        const SizedBox(width: 4),
                        Text(product['rating'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mock Data
final List<Map<String, dynamic>> _defaultProducts = [
  {
    "name": "Philip T-Shirt",
    "price": "\$20.82",
    "rating": 8.2,
    "image": "https://via.placeholder.com/300x300?text=T-Shirt+1"
  },
  {
    "name": "Flap T-Shirt",
    "price": "\$23.82",
    "rating": 5.2,
    "image": "https://via.placeholder.com/300x300?text=T-Shirt+2"
  },
  {
    "name": "Olive Tee",
    "price": "\$18.90",
    "rating": 7.5,
    "image": "https://via.placeholder.com/300x300?text=T-Shirt+3"
  },
  {
    "name": "Street Style",
    "price": "\$29.50",
    "rating": 9.0,
    "image": "https://via.placeholder.com/300x300?text=T-Shirt+4"
  },
];

// --- Custom Bottom Nav ---
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: LucideIcons.house, selected: true),
          _NavItem(icon: LucideIcons.shoppingBag),
          _NavItem(icon: LucideIcons.heart),
          _NavItem(icon: LucideIcons.user),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _NavItem({required this.icon, this.selected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 26,
      color: selected ? Colors.yellowAccent : Colors.white,
    );
  }
}
