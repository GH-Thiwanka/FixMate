import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class EditProfileSheet extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String initialEmail;
  final Function(String name, String phone, String email) onSave;

  const EditProfileSheet({
    super.key,
    required this.initialName,
    required this.initialPhone,
    required this.initialEmail,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required String name,
    required String phone,
    required String email,
    required Function(String name, String phone, String email) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => EditProfileSheet(
        initialName: name,
        initialPhone: phone,
        initialEmail: email,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Edit Profile', style: AppTextStyles.h2),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Full Name
          const Text('Full Name', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 6),
          _buildTextField(
            _nameController,
            'Enter full name',
            Icons.person_outline_rounded,
          ),
          const SizedBox(height: 14),

          // Phone Number
          const Text('Phone Number', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 6),
          _buildTextField(
            _phoneController,
            'Enter phone number',
            Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),

          // Email
          const Text('Email Address', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 6),
          _buildTextField(
            _emailController,
            'Enter email address',
            Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _nameController.text.trim(),
                  _phoneController.text.trim(),
                  _emailController.text.trim(),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: AppTextStyles.buttonPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.inputText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          hintText: hint,
          hintStyle: AppTextStyles.inputHint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
