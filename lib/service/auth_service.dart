import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register Customer strictly using Firebase
  static Future<Map<String, dynamic>> registerCustomer({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // 1. Create account in Firebase Authentication
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      final User? user = userCredential.user;
      if (user == null) {
        return {'success': false, 'message': 'Failed to create user.'};
      }

      // 2. Set Display Name in Firebase Auth
      await user.updateDisplayName(fullName.trim());

      // 3. Send Firebase Email Verification Link
      await user.sendEmailVerification();

      // 3. Save User Profile in Firebase Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'userType': 'customer',
        'email': email.trim().toLowerCase(),
        'fullName': fullName.trim(),
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Account created! Verification email sent.',
        'userId': user.uid,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Authentication error occurred.';
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'An account with this email already exists. Please log in.';
      } else if (e.code == 'weak-password') {
        errorMessage =
            'Password is too weak. Please use at least 8 characters.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address.';
      }
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Login Method - Only allows verified users
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      final User? user = userCredential.user;

      if (user != null) {
        // 1. Reload the user to get the latest emailVerified status from Firebase
        await user.reload();
        final refreshedUser = _auth.currentUser;

        // 2. Check if the email is verified
        if (refreshedUser != null && !refreshedUser.emailVerified) {
          // Sign out immediately so an unverified session is not active
          await _auth.signOut();
          return {
            'success': false,
            'message': 'Please verify your email address before logging in. Check your inbox/spam.',
            'isVerified': false,
          };
        }
      }

      return {'success': true, 'userId': user?.uid};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed.';
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address.';
      }
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Send Password Reset Email via Firebase
  static Future<Map<String, dynamic>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return {
        'success': true,
        'message': 'Password reset link sent! Check your inbox.',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to send password reset email.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email address.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address.';
      }
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// 4. Change Password for logged-in user (re-authenticates and updates)
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return {
          'success': false,
          'message': 'No logged-in user found. Please log in again.',
        };
      }

      // 1. Re-authenticate user with current password
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);

      // 2. Update to new password
      await user.updatePassword(newPassword);

      return {'success': true, 'message': 'Password updated successfully!'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to update password.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Your current password is incorrect.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'New password is too weak. Please use at least 8 characters.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Please log out and log in again before changing password.';
      }
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
