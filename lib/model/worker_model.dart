class WorkerModel {
  final String id;
  final String name;
  final String category;
  final List<String> subServices;
  final double rating;
  final int reviewCount;
  final double priceRate;
  final String priceUnit;
  final String about;
  final String? imageUrl;
  final bool isVerified;
  final String location;
  final String? createdAt;

  WorkerModel({
    required this.id,
    required this.name,
    required this.category,
    this.subServices = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.priceRate = 0.0,
    this.priceUnit = 'hr',
    this.about = '',
    this.imageUrl,
    this.isVerified = false,
    this.location = 'Local',
    this.createdAt,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'FixMate Pro',
      category: json['category'] as String? ?? 'General',
      subServices: (json['subServices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      reviewCount: (json['reviewCount'] is num) ? (json['reviewCount'] as num).toInt() : 0,
      priceRate: (json['priceRate'] is num) ? (json['priceRate'] as num).toDouble() : 0.0,
      priceUnit: json['priceUnit'] as String? ?? 'hr',
      about: json['about'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      location: json['location'] as String? ?? 'Local',
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subServices': subServices,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRate': priceRate,
      'priceUnit': priceUnit,
      'about': about,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
      'location': location,
      'createdAt': createdAt,
    };
  }
}
