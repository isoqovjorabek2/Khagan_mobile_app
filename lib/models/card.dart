class Card {
  final int? id;
  final String cardName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String? addedAt;

  Card({
    this.id,
    required this.cardName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    this.addedAt,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      cardName: json['card_name'] ?? '',
      cardNumber: json['card_number'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      cvv: json['cvv'] ?? '',
      addedAt: json['added_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_name': cardName,
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'added_at': addedAt,
    };
  }
}

