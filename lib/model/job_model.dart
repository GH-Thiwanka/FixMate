enum JobStatus {
  quoteReceived,
  confirmed,
  workerOnTheWay,
  inProgress,
  awaitingPayment,
  completed,
  cancelled,
}

enum JobTabType { active, upcoming, completed, cancelled }

class JobModel {
  final String id;
  final String title;
  final String category;
  final String? subService;
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
  final String? description;
  final String? propertyType;
  final String? urgency;
  final List<String> photoUrls;
  final double? latitude;
  final double? longitude;
  final String? budgetPreference;
  final bool broadcastToAll;
  final String? customerId;
  final String? createdAt;

  const JobModel({
    required this.id,
    required this.title,
    required this.category,
    this.subService,
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
    this.description,
    this.propertyType,
    this.urgency,
    this.photoUrls = const [],
    this.latitude,
    this.longitude,
    this.budgetPreference,
    this.broadcastToAll = true,
    this.customerId,
    this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['status'] as String? ?? 'PENDING').toUpperCase();
    JobStatus parsedStatus;
    JobTabType parsedTab;
    String parsedStatusText;

    switch (rawStatus) {
      case 'QUOTES_RECEIVED':
      case 'QUOTE_RECEIVED':
        parsedStatus = JobStatus.quoteReceived;
        parsedTab = JobTabType.active;
        parsedStatusText = 'Quotes Received';
        break;
      case 'CONFIRMED':
        parsedStatus = JobStatus.confirmed;
        parsedTab = JobTabType.upcoming;
        parsedStatusText = 'Confirmed';
        break;
      case 'WORKER_ON_THE_WAY':
      case 'ON_THE_WAY':
        parsedStatus = JobStatus.workerOnTheWay;
        parsedTab = JobTabType.active;
        parsedStatusText = 'Worker on the Way';
        break;
      case 'IN_PROGRESS':
        parsedStatus = JobStatus.inProgress;
        parsedTab = JobTabType.active;
        parsedStatusText = 'In Progress';
        break;
      case 'AWAITING_PAYMENT':
        parsedStatus = JobStatus.awaitingPayment;
        parsedTab = JobTabType.active;
        parsedStatusText = 'Awaiting Payment';
        break;
      case 'COMPLETED':
        parsedStatus = JobStatus.completed;
        parsedTab = JobTabType.completed;
        parsedStatusText = 'Completed';
        break;
      case 'CANCELLED':
      case 'CANCELED':
        parsedStatus = JobStatus.cancelled;
        parsedTab = JobTabType.cancelled;
        parsedStatusText = 'Cancelled';
        break;
      case 'PENDING':
      default:
        parsedStatus = JobStatus.quoteReceived;
        parsedTab = JobTabType.active;
        parsedStatusText = 'Pending Quotes';
        break;
    }

    final double? parsedPrice = (json['price'] is num)
        ? (json['price'] as num).toDouble()
        : double.tryParse(json['budget']?.toString() ?? '');

    final int quotes = (json['quoteCount'] is num)
        ? (json['quoteCount'] as num).toInt()
        : 0;

    String formatDateTime() {
      if (json['scheduledDate'] != null) {
        final date = json['scheduledDate'];
        final time = json['scheduledTime'] ?? 'Anytime';
        return date + ' • ' + time;
      }
      return json['dateTime'] as String? ?? 'Scheduled';
    }

    return JobModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['category'] as String? ?? 'Job Request',
      category: json['category'] as String? ?? 'General',
      subService: json['subService'] as String?,
      serviceIcon: json['serviceIcon'] as String? ?? 'assets/icons/paint.svg',
      status: parsedStatus,
      statusText: json['statusText'] as String? ?? parsedStatusText,
      dateTime: formatDateTime(),
      address: json['address'] as String? ?? 'Location Provided',
      price: parsedPrice,
      quoteCount: quotes,
      workerName: json['workerName'] as String?,
      workerAvatar: json['workerAvatar'] as String?,
      workerRating: (json['workerRating'] is num)
          ? (json['workerRating'] as num).toDouble()
          : null,
      paymentMethod: json['paymentMethod'] as String?,
      tab: parsedTab,
      description: json['description'] as String?,
      propertyType: json['propertyType'] as String?,
      urgency: json['urgency'] as String?,
      photoUrls: (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : null,
      budgetPreference: json['budgetPreference'] as String?,
      broadcastToAll: json['broadcastToAll'] as bool? ?? true,
      customerId: json['customerId'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'subService': subService,
      'serviceIcon': serviceIcon,
      'status': status.name,
      'statusText': statusText,
      'dateTime': dateTime,
      'address': address,
      'price': price,
      'quoteCount': quoteCount,
      'workerName': workerName,
      'workerAvatar': workerAvatar,
      'workerRating': workerRating,
      'paymentMethod': paymentMethod,
      'description': description,
      'propertyType': propertyType,
      'urgency': urgency,
      'photoUrls': photoUrls,
      'latitude': latitude,
      'longitude': longitude,
      'budgetPreference': budgetPreference,
      'broadcastToAll': broadcastToAll,
      'customerId': customerId,
      'createdAt': createdAt,
    };
  }
}
