import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmate/model/user_model.dart';
import 'package:fixmate/service/s3_upload_service.dart';
import 'package:fixmate/service/user_service.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/bottumnavbar.dart';
import 'package:fixmate/widget/profile/change_password_sheet.dart';
import 'package:fixmate/widget/profile/edit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _selectedBottomNavIndex = 3;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingAvatar = false;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirm Logout', style: AppTextStyles.h2),
          content: const Text(
            'Are you sure you want to log out of FixMate?',
            style: AppTextStyles.subtitleSmall,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final router = GoRouter.of(context);
                Navigator.pop(dialogCtx); // Close dialog
                await FirebaseAuth.instance.signOut(); // Sign out of Firebase
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('Logged out successfully.')),
                );
                router.go('/selection'); // Navigate to Selection/Login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleAvatarPick(String userId) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.primary,
              ),
              title: const Text(
                'Choose from Gallery',
                style: AppTextStyles.bodyMedium,
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                  maxWidth: 800,
                );
                if (picked != null) {
                  _uploadAvatar(File(picked.path), userId);
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.primary,
              ),
              title: const Text(
                'Take a Photo',
                style: AppTextStyles.bodyMedium,
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                  maxWidth: 800,
                );
                if (picked != null) {
                  _uploadAvatar(File(picked.path), userId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAvatar(File imageFile, String userId) async {
    setState(() => _isUploadingAvatar = true);

    try {
      // Upload to Amazon S3 via Pre-signed URL
      final s3Url = await S3UploadService.uploadProfileImage(
        imageFile: imageFile,
        userId: userId,
      );

      if (s3Url != null) {
        await UserService.updateProfileImageUrl(uid: userId, imageUrl: s3Url);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not upload image to S3. Please verify AWS S3 configuration.',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String currentUid = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Profile', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: currentUid.isEmpty
            ? const Center(child: Text('Please log in to view profile'))
            : StreamBuilder<UserModel?>(
                stream: UserService.streamUserProfile(currentUid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint(
                      'Firestore Profile Stream Error: ${snapshot.error}',
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }

                  final user = snapshot.data;
                  final String displayName = (user?.fullName.isNotEmpty == true)
                      ? user!.fullName
                      : ((currentUser?.displayName?.isNotEmpty == true)
                            ? currentUser!.displayName!
                            : 'FixMate User');
                  final String displayEmail = (user?.email.isNotEmpty == true)
                      ? user!.email
                      : (currentUser?.email ?? '');
                  final String displayPhone =
                      (user?.phoneNumber.isNotEmpty == true)
                      ? user!.phoneNumber
                      : 'No phone added';
                  final String? avatarUrl =
                      user?.profileImageUrl ?? currentUser?.photoURL;
                  final int completedJobs = user?.completedJobsCount ?? 0;
                  final int savedPros = user?.savedProsCount ?? 0;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      children: [
                        // ==============================================================
                        // 1. PROFILE HEADER CARD
                        // ==============================================================
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Avatar with Camera Edit Badge
                                  GestureDetector(
                                    onTap: _isUploadingAvatar
                                        ? null
                                        : () => _handleAvatarPick(currentUid),
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 34,
                                          backgroundColor:
                                              AppColors.primarySoft,
                                          backgroundImage:
                                              avatarUrl != null &&
                                                  avatarUrl.isNotEmpty
                                              ? NetworkImage(avatarUrl)
                                              : null,
                                          child:
                                              avatarUrl == null ||
                                                  avatarUrl.isEmpty
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 36,
                                                  color: AppColors.primary,
                                                )
                                              : null,
                                        ),
                                        if (_isUploadingAvatar)
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_rounded,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayName,
                                          style: AppTextStyles.h2.copyWith(
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          displayPhone,
                                          style: AppTextStyles.subtitleSmall,
                                        ),
                                        Text(
                                          displayEmail,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Edit Profile Button
                                  OutlinedButton(
                                    onPressed: () {
                                      EditProfileSheet.show(
                                        context,
                                        name: displayName,
                                        phone: displayPhone == 'No phone added'
                                            ? ''
                                            : displayPhone,
                                        email: displayEmail,
                                        onSave: (newName, newPhone) async {
                                          final messenger =
                                              ScaffoldMessenger.of(context);
                                          final result =
                                              await UserService.updateUserProfile(
                                                uid: currentUid,
                                                fullName: newName,
                                                phoneNumber: newPhone,
                                              );
                                          messenger.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                result['message'] ??
                                                    'Profile updated',
                                              ),
                                              backgroundColor:
                                                  result['success'] == true
                                                  ? AppColors.success
                                                  : AppColors.error,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Quick Stat Badges
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatBadge(
                                      icon: Icons.assignment_turned_in_outlined,
                                      label: '$completedJobs Completed Jobs',
                                      color: const Color(0xFF0756A6),
                                      bgColor: const Color(0xFFE8F3FF),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildStatBadge(
                                      icon: Icons.favorite_rounded,
                                      label: '$savedPros Saved Pros',
                                      color: const Color(0xFFE11D48),
                                      bgColor: const Color(0xFFFFE4E6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ==============================================================
                        // 2. SETTINGS MENU LIST ITEMS
                        // ==============================================================
                        _buildMenuCard([
                          _buildMenuItem(
                            icon: Icons.location_on_outlined,
                            iconColor: const Color(0xFF0756A6),
                            title: 'Saved Addresses',
                            subtitle: 'Manage home, office and site locations',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening Saved Addresses...'),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.favorite_outline_rounded,
                            iconColor: const Color(0xFFE11D48),
                            title: 'Saved Workers (Favorites)',
                            subtitle: 'Quick access to your preferred pros',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.account_balance_wallet_outlined,
                            iconColor: const Color(0xFF168A55),
                            title: 'Payment Methods & Invoices',
                            subtitle: 'Manage cards, wallet & download PDFs',
                            onTap: () {},
                          ),
                        ]),

                        const SizedBox(height: 14),

                        _buildMenuCard([
                          _buildMenuItem(
                            icon: Icons.lock_reset_rounded,
                            iconColor: AppColors.primary,
                            title: 'Change Password',
                            subtitle: 'Update your account security password',
                            onTap: () => ChangePasswordSheet.show(context),
                          ),
                          _buildMenuItem(
                            icon: Icons.notifications_none_rounded,
                            iconColor: const Color(0xFFF59E0B),
                            title: 'Notifications & Alerts',
                            subtitle: 'Booking updates & quote reminders',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.headset_mic_outlined,
                            iconColor: AppColors.primary,
                            title: 'Help & Support',
                            subtitle: 'FAQs, live chat and dispute resolution',
                            onTap: () => context.push('/refund-and-support'),
                          ),
                          _buildMenuItem(
                            icon: Icons.description_outlined,
                            iconColor: AppColors.textSecondary,
                            title: 'Terms & Privacy Policy',
                            subtitle: 'Terms of service and safety rules',
                            onTap: () {},
                            isLast: true,
                          ),
                        ]),

                        const SizedBox(height: 20),

                        // ==============================================================
                        // 3. LOGOUT BUTTON
                        // ==============================================================
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _showLogoutDialog,
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFEF4444),
                              size: 18,
                            ),
                            label: const Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFEF4444)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
      ),

      // ==============================================================
      // 4. PERSISTENT 4-TAB BOTTOM NAVIGATION BAR
      // ==============================================================
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          if (index == _selectedBottomNavIndex) return;
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/my-jobs');
              break;
            case 2:
              context.go('/messages');
              break;
            case 3:
              // Already on Profile
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.textSecondary,
          ),
        ),
        if (!isLast)
          const Divider(color: AppColors.divider, height: 1, indent: 60),
      ],
    );
  }
}
