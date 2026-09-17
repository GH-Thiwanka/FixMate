import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String userType;
  final String? profileImageUrl;
  final int completedJobsCount;
  final int savedProsCount;
  final DateTime? createdAt;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.userType = 'customer',
    this.profileImageUrl,
    this.completedJobsCount = 0,
    this.savedProsCount = 0,
    this.createdAt,
  });

  /// Factory constructor to parse data from Cloud Firestore document snapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime? parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    }

    return UserModel(
      userId: data['userId'] ?? doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      userType: data['userType'] ?? 'customer',
      profileImageUrl: data['profileImageUrl'],
      completedJobsCount: (data['completedJobsCount'] as num?)?.toInt() ?? 0,
      savedProsCount: (data['savedProsCount'] as num?)?.toInt() ?? 0,
      createdAt: parsedCreatedAt,
    );
  }

  /// Convert model to Map for saving in Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'userType': userType,
      'profileImageUrl': profileImageUrl,
      'completedJobsCount': completedJobsCount,
      'savedProsCount': savedProsCount,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  /// Helper to create a copy of the model with updated fields
  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? userType,
    String? profileImageUrl,
    int? completedJobsCount,
    int? savedProsCount,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      completedJobsCount: completedJobsCount ?? this.completedJobsCount,
      savedProsCount: savedProsCount ?? this.savedProsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
