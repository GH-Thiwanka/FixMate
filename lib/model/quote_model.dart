class QuoteModel {
  final String id;
  final String jobId;
  final String workerName;
  final String workerTrade;
  final String workerAvatar;
  final double workerRating;
  final int reviewCount;
  final String distance;
  final bool isVerified;
  final bool isRecommended;
  final double totalAmount;
  final double labourCost;
  final double materialsCost;
  final double visitCharge;
  final String estimatedDuration;
  final int warrantyDays;
  final String scopeOfWork;
  final String submittedTime;

  const QuoteModel({
    required this.id,
    required this.jobId,
    required this.workerName,
    required this.workerTrade,
    required this.workerAvatar,
    required this.workerRating,
    required this.reviewCount,
    required this.distance,
    this.isVerified = true,
    this.isRecommended = false,
    required this.totalAmount,
    required this.labourCost,
    required this.materialsCost,
    this.visitCharge = 1000,
    required this.estimatedDuration,
    this.warrantyDays = 30,
    required this.scopeOfWork,
    required this.submittedTime,
  });
}
