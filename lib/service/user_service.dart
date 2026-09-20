import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmate/model/user_model.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch a single user profile from Firestore by User ID
  static Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user profile: $e');
      return null;
    }
  }

  /// Real-time stream of the user profile document in Firestore
  static Stream<UserModel?> streamUserProfile(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return UserModel.fromFirestore(snapshot);
          }
          return null;
        });
  }

  /// Update user profile details (fullName, phoneNumber, optional profileImageUrl)
  static Future<Map<String, dynamic>> updateUserProfile({
    required String uid,
    required String fullName,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'fullName': fullName.trim(),
        'phoneNumber': phoneNumber.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      // 1. Update/Merge Firestore Document
      await _firestore
          .collection('users')
          .doc(uid)
          .set(updateData, SetOptions(merge: true));

      // 2. Sync Display Name in Firebase Auth
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(fullName.trim());
        if (profileImageUrl != null) {
          await currentUser.updatePhotoURL(profileImageUrl);
        }
      }

      return {
        'success': true,
        'message': 'Profile updated successfully!',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update profile: $e',
      };
    }
  }

  /// Update only the user's profile image URL
  static Future<bool> updateProfileImageUrl({
    required String uid,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updatePhotoURL(imageUrl);
      }
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error updating profile image URL: $e');
      return false;
    }
  }
}
