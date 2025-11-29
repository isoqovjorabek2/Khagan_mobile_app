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
    return Advertisement(
      id: json['id'],
      image: json['image'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'],
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

