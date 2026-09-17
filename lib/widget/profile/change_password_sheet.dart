import 'package:fixmate/service/auth_service.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/auth_and_onboarding/textfieldwidget.dart';
import 'package:flutter/material.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ChangePasswordSheet(),
    );
  }

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // Password validation checks (Matching Signup Screen)
  bool get _hasMinLength => _newPasswordController.text.length >= 8;
  bool get _hasNumberAndSymbol =>
      RegExp(r'[0-9]').hasMatch(_newPasswordController.text) &&
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_newPasswordController.text);
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_newPasswordController.text);

  bool get _isPasswordValid => _hasMinLength && _hasNumberAndSymbol && _hasUppercase;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please meet all password requirements.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New passwords do not match.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      final result = await AuthService.changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        Navigator.pop(context); // Close sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to change password.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Change Password', style: AppTextStyles.h2),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. Current Password
              const Text('Current Password', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _currentPasswordController,
                hintText: 'Enter your current password',
                prefixIcon: Icons.lock_clock_outlined,
                isPasswordField: true,
                validatorText: 'Please enter your current password',
              ),
              const SizedBox(height: 14),

              // 2. New Password
              const Text('New Password', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _newPasswordController,
                hintText: 'Enter new password',
                prefixIcon: Icons.lock_outline_rounded,
                isPasswordField: true,
                validatorText: 'Please enter a new password',
              ),
              const SizedBox(height: 10),

              // 3. Password Requirements Checklist (Same as Signup)
              _PasswordRequirementItem(
                text: 'At least 8 characters',
                isValid: _hasMinLength,
              ),
              const SizedBox(height: 5),
              _PasswordRequirementItem(
                text: 'Include number and symbol',
                isValid: _hasNumberAndSymbol,
              ),
              const SizedBox(height: 5),
              _PasswordRequirementItem(
                text: 'Must contain uppercase letter',
                isValid: _hasUppercase,
              ),
              const SizedBox(height: 14),

              // 4. Confirm New Password
              const Text('Confirm New Password', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Re-enter new password',
                prefixIcon: Icons.lock_outline_rounded,
                isPasswordField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 5. Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isLoading ? 'Updating...' : 'Update Password',
                    style: AppTextStyles.buttonPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirementItem extends StatelessWidget {
  final String text;
  final bool isValid;

  const _PasswordRequirementItem({required this.text, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 15,
          color: isValid ? AppColors.success : AppColors.textLight,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.subtitleSmall.copyWith(
            fontSize: 12.5,
            color: isValid ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isValid ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
