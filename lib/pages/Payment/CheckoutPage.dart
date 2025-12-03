import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../models/card.dart' as payment_model;
import '../../services/cart_service.dart';
import 'AddCardPage.dart';
import 'PaymentCompletePage.dart';

class CheckoutPage extends StatefulWidget {
  final double? total;

  const CheckoutPage({super.key, this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CartService _cartService = CartService();
  List<payment_model.Card> _cards = [];
  bool _isLoadingCards = true;
  bool _isProcessingPayment = false;
  int? _selectedCardId;

  double get _billing => (widget.total ?? 160.25) * 0.38;
  double get _shipping => 20.13;
  double get _tax => 15.48;
  double get _total => widget.total ?? 160.25;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => _isLoadingCards = true);
    try {
      final cards = await _cartService.getCards();
      setState(() {
        _cards = cards;
        _selectedCardId = cards.isNotEmpty ? _cardKey(cards.first) : null;
        _isLoadingCards = false;
      });
    } catch (e) {
      setState(() => _isLoadingCards = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cards: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _onAddCard() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const AddCardPage(),
      ),
    );
    if (added == true) {
      await _loadCards();
    }
  }

  Future<void> _onPay() async {
    if (_selectedCardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a card first')),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);
    try {
      final orderResult = await _cartService.orderCart();
      final orderCode =
          orderResult.orderCode ?? '#${Random().nextInt(900000) + 100000}';
      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentCompletePage(orderCode: orderCode),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, size: 20, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _paymentMethods(),
            const SizedBox(height: 20),
            _priceSection(),
            const SizedBox(height: 25),
            _paymentMethodCard(),
            const SizedBox(height: 35),
            _payButton(),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethods() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Image.asset('lib/assets/mastercard.png', width: 55),
          const SizedBox(width: 120),
          Image.asset('lib/assets/paypal.png', height: 35),
          const Spacer(),
          Image.asset('lib/assets/applepay.png', height: 28),
        ],
      ),
    );
  }

  Widget _priceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line('Billing', _billing.toStringAsFixed(2)),
        _line('Shipping', _shipping.toStringAsFixed(2)),
        _line('Tax (9.52%)', _tax.toStringAsFixed(2)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '\$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _paymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                'Edit',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_isLoadingCards)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (_cards.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade100,
              ),
              child: const Text(
                'No cards yet. Please add a card.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          else
            Column(
              children: _cards.map((card) => _cardTile(card)).toList(),
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _onAddCard,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFD8E047),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.plus, size: 20, color: Colors.black),
                  const SizedBox(width: 8),
                  const Text(
                    'Add Your Card',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTile(payment_model.Card card) {
    final cardKey = _cardKey(card);
    final isSelected = _selectedCardId == cardKey;
    final masked = card.cardNumber.length >= 4
        ? '•••• •••• •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}'
        : card.cardNumber;

    return GestureDetector(
      onTap: () => setState(() => _selectedCardId = _cardKey(card)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isSelected ? 0.1 : 0.8),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(Icons.radio_button_checked, color: Colors.white)
                  : const Icon(Icons.radio_button_off, color: Colors.black54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.cardName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        masked,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        card.expiryDate,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _cardBrandIcon(card.cardNumber, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _cardBrandIcon(String number, bool isSelected) {
    final color = isSelected ? Colors.white : Colors.orange.shade400;
    if (number.startsWith('4')) {
      return Icon(Icons.credit_card, color: color, size: 28);
    }
    if (number.startsWith('5')) {
      return Image.asset('lib/assets/mastercard.png', width: 36);
    }
    return Icon(Icons.payment, color: color, size: 28);
  }

  int _cardKey(payment_model.Card card) {
    return card.id ?? card.hashCode;
  }

  Widget _payButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _isProcessingPayment ? null : _onPay,
        child: _isProcessingPayment
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Use this Card',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
