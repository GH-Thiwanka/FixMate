enum JobStatus {
  quoteReceived, // Blue #0756A6
  confirmed, // Blue #0756A6
  workerOnTheWay, // Orange #F47C20
  inProgress, // Orange #F47C20
  awaitingPayment, // Orange #F47C20
  completed, // Green #168A55
  cancelled, // Red #C93636
}

enum JobTabType { active, upcoming, completed, cancelled }

class JobModel {
  final String id;
  final String title;
  final String category;
  final String serviceIcon;
  final JobStatus status;
  final String statusText;
  final String dateTime;
  final String address;
  final double? price;
  final int quoteCount;
  final String? workerName;
  final String? workerAvatar;
  final double? workerRating;
  final String? paymentMethod;
  final JobTabType tab;

  const JobModel({
    required this.id,
    required this.title,
    required this.category,
    required this.serviceIcon,
    required this.status,
    required this.statusText,
    required this.dateTime,
    required this.address,
    this.price,
    this.quoteCount = 0,
    this.workerName,
    this.workerAvatar,
    this.workerRating,
    this.paymentMethod,
    required this.tab,
  });
}
