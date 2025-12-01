class Advertisement {
  final int? id;
  final String? image;
  final String title;
  final String description;
  final String? createdAt;

  Advertisement({
    this.id,
    this.image,
    required this.title,
    required this.description,
    this.createdAt,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    // Handle image URL - convert relative path to full URL if needed
    String? imageUrl;
    if (json['image'] != null) {
      final image = json['image'].toString();
      if (image.startsWith('http://') || image.startsWith('https://')) {
        // Ensure we use https://
        imageUrl = image.replaceFirst('http://', 'https://');
      } else if (image.isNotEmpty) {
        // If it's a relative path, prepend base URL with https://
        imageUrl = 'https://khagan.univibe.uz$image';
      }
    }

    return Advertisement(
      id: json['id'],
      image: imageUrl,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'created_at': createdAt,
    };
  }
}

