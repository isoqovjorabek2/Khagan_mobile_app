import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final int? productId;

  const ProductDetailsPage({super.key, this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  Product? _product;
  bool _isLoading = true;
  bool _isAddingToCart = false;
  String selectedColor = "green";
  String selectedSize = "M";

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    setState(() => _isLoading = true);
    try {
      final product = await _productService.getProductById(widget.productId!);
      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading product: $e')),
        );
      }
    }
  }

  Future<void> _addToCart() async {
    if (_product?.id == null) return;

    setState(() => _isAddingToCart = true);
    try {
      await _cartService.addProductToCart(_product!.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () => _showShareSheet(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _product == null
              ? const Center(child: Text('Product not found'))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _product!.image != null
                                    ? Image.network(
                                        _product!.image!,
                                        width: double.infinity,
                                        height: 300,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          height: 300,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image,
                                              size: 50),
                                        ),
                                      )
                                    : Container(
                                        height: 300,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image, size: 50),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          _product!.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _product!.price != null
                              ? '\$${_product!.price}'
                              : r'$0.00',
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          "Description",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _product!.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorSelector(),
                  _sizeSelector(),
                ],
              ),
              const SizedBox(height: 30),

              // Bottom Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Price",
                              style: TextStyle(color: Colors.white54),
                            ),
                            Text(
                              _product!.price != null
                                  ? '\$${_product!.price}'
                                  : '\$0.00',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _isAddingToCart ? null : _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDBFF00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                          ),
                          child: _isAddingToCart
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                )
                              : const Text(
                                  "Add to Cart",
                                  style:
                                      TextStyle(color: Colors.black, fontSize: 16),
                                ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorSelector() {
    final colors = {
      "green": Colors.green.shade300,
      "black": Colors.black,
      "grey": Colors.grey,
      "brown": Colors.brown.shade300,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Color",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: colors.entries.map((e) {
            final selected = selectedColor == e.key;
            return GestureDetector(
              onTap: () => setState(() => selectedColor = e.key),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: e.value,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: selected ? Colors.black : Colors.transparent,
                      width: 2),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _sizeSelector() {
    final sizes = ["S", "M", "L", "XL"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Size",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: sizes.map((s) {
            final selected = selectedSize == s;
            return GestureDetector(
              onTap: () => setState(() => selectedSize = s),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? Colors.red.shade300 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final icons = [
          ["WhatsApp", LucideIcons.messageSquare],
          ["Facebook", LucideIcons.facebook],
          ["Instagram", LucideIcons.instagram],
          ["Twitter", LucideIcons.twitter],
          ["LinkedIn", LucideIcons.linkedin],
          ["WeChat", LucideIcons.messageCircle],
          ["Yahoo", LucideIcons.mail],
          ["TikTok", LucideIcons.music],
        ];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Share",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 30,
                runSpacing: 20,
                children: icons.map((item) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(item[1] as IconData,
                            size: 28, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      Text(item[0] as String,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
