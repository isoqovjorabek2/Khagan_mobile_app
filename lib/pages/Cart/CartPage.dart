import 'package:flutter/material.dart';
import '../../models/cart.dart';
import '../../services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  List<Cart> _cartItems = [];
  bool _isLoading = true;
  bool confirming = false;
  bool deleting = false;
  bool renting = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void refresh() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final items = await _cartService.getCart();
      setState(() {
        _cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading cart: $e')),
        );
      }
    }
  }

  double get total {
    return _cartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.totalPrice ?? item.product.price ?? '0') ?? 0.0;
      return sum + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${_cartItems.length} Items",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(
                  child: Text('Your cart is empty',
                      style: TextStyle(fontSize: 16, color: Colors.grey)))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = _cartItems[index];
                          final product = cartItem.product;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16)),
                                  child: product.image != null
                                      ? Image.network(product.image!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.image),
                                              ))
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image),
                                        ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(product.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        if (product.category != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            product.category!.name,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                _quantityButton(index, -1),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                  child: Text(
                                                    "${cartItem.quantity}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                _quantityButton(index, 1),
                                              ],
                                            ),
                                            Text(
                                              "\$${(double.tryParse(cartItem.totalPrice ?? product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.redAccent),
                                  onPressed: () => _deleteProduct(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Bottom section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border(top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "\$${total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      confirming = true;
                                      deleting = false;
                                      renting = false;
                                    });
                                    _showBottomSheet(context);
                                  },
                                  style: _buttonStyle(),
                                  child: const Text("Confirm"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      confirming = false;
                                      deleting = false;
                                      renting = true;
                                    });
                                    _showBottomSheet(context);
                                  },
                                  style: _buttonStyle(),
                                  child: const Text("Rent"),
                                ),
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

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  Future<void> _updateQuantity(int index, int change) async {
    final cartItem = _cartItems[index];
    final newQuantity = cartItem.quantity + change;
    if (newQuantity <= 0) {
      await _deleteProduct(index);
      return;
    }

    try {
      // Remove old item and add with new quantity
      await _cartService.deleteProductFromCart(cartItem.productId);
      await _cartService.addProductToCart(cartItem.productId,
          quantity: newQuantity);
      await _loadCart();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating quantity: $e')),
        );
      }
    }
  }

  Future<void> _deleteProduct(int index) async {
    final cartItem = _cartItems[index];
    try {
      final success = await _cartService.deleteProductFromCart(cartItem.productId);
      if (success) {
        await _loadCart();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product removed from cart')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting product: $e')),
        );
      }
    }
  }

  Widget _quantityButton(int index, int change) {
    return GestureDetector(
      onTap: () => _updateQuantity(index, change),
      child: Container(
        decoration: BoxDecoration(
          color: change == 1 ? Colors.yellow.shade600 : Colors.orange.shade200,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(
          change == 1 ? Icons.add : Icons.remove,
          size: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: confirming
              ? _confirmSection()
              : renting
                  ? _rentSection()
                  : const SizedBox(),
        );
      },
    );
  }

  Widget _confirmSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Use Promotional Code",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Text("Promo Code Input Placeholder")),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: _buttonStyle(),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final success = await _cartService.orderCart();
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order confirmed!')),
                  );
                  await _loadCart();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error confirming order: $e')),
                  );
                }
              }
            },
            child: const Text("Apply & Confirm"),
          ),
        ),
      ],
    );
  }

  Widget _rentSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Make Payment",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total"),
            Text(
              "\$${total.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                  fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: _buttonStyle(),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final success = await _cartService.orderCart();
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment processed!')),
                  );
                  await _loadCart();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error processing payment: $e')),
                  );
                }
              }
            },
            child: const Text("Make Payment"),
          ),
        ),
      ],
    );
  }
}
