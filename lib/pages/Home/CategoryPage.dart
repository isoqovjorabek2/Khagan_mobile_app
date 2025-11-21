import 'package:flutter/material.dart';
import 'package:helloworld/pages/Home/HomePage.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String selectedCategory = "Men";

  final List<Map<String, dynamic>> _defaultProducts = [
    {
      "name": "Stone Gray T-Shirt",
      "price": "\$15.89",
      "image": "https://via.placeholder.com/300x400?text=Stone+Gray+T-Shirt",
    },
    {
      "name": "Slate-Hued T-Shirt",
      "price": "\$15.89",
      "image": "https://via.placeholder.com/300x400?text=Slate+Hued+T-Shirt",
    },
    {
      "name": "Philip's Top Tee",
      "price": "\$25.03",
      "image": "https://via.placeholder.com/300x400?text=Philip+Top+Tee",
    },
    {
      "name": "Slate T-Shirt",
      "price": "\$17.89",
      "image": "https://via.placeholder.com/300x400?text=Slate+T-Shirt",
    },
  ];

  final List<Map<String, dynamic>> _emptyProducts = [];

  @override
  Widget build(BuildContext context) {
    final bool hasProducts =
        selectedCategory == "Men" ? _defaultProducts.isNotEmpty : false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black),
                    onPressed: () {
                      // ✅ Go back to HomePage instead of just popping
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                  ),
                  const Text(
                    "Category",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip("All"),
                    _buildCategoryChip("Women"),
                    _buildCategoryChip("Men"),
                    _buildCategoryChip("Children"),
                    _buildCategoryChip("Kids"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Search bar
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
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
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
                    child: const Icon(Icons.filter_list, color: Colors.black),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "New For Men",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Product Grid OR Empty Placeholder
              if (hasProducts)
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
                )
              else
                _buildEmptyState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final bool selected = label == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
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
            child: Image.network(
              product['image'],
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
                Text(
                  product['price'],
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 20, color: Colors.grey[700]),
                    Icon(Icons.shopping_bag_outlined,
                        size: 20, color: Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: const [
            Icon(Icons.sentiment_dissatisfied, size: 70, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "404 - No products found",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            SizedBox(height: 6),
            Text(
              "Try selecting a different category.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
