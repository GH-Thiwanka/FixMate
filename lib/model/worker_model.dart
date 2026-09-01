class WorkerModel {
  String name;
  String service;
  String rating;
  String? imageUrl;
  String reviewCount;
  String price;
  String distance;

  WorkerModel({
    required this.name,
    required this.service,
    required this.rating,
    this.imageUrl,
    required this.reviewCount,
    required this.price,
    required this.distance,
  });
}
