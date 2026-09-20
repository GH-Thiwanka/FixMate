import 'package:fixmate/data/flag_data.dart';
import 'package:fixmate/model/flag_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileSheet extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String initialEmail;
  final Future<void> Function(String name, String phone) onSave;

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
    required Future<void> Function(String name, String phone) onSave,
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  late String _selectedCountryCode;
  late String _selectedCountryFlag;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);

    // Parse and separate initial phone number into Country Code and Digits
    String rawInitial = widget.initialPhone.trim();
    String detectedCode = '+94';
    String detectedFlag = '🇱🇰';

    if (rawInitial.isNotEmpty) {
      for (final flag in FlagData.flags) {
        if (rawInitial.startsWith(flag.code)) {
          detectedCode = flag.code;
          detectedFlag = flag.flag;
          rawInitial = rawInitial.substring(flag.code.length).trim();
          break;
        }
      }
    }

    _selectedCountryCode = detectedCode;
    _selectedCountryFlag = detectedFlag;
    _phoneController = TextEditingController(text: rawInitial);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      try {
        // Strip any leading 0 or spaces from the local phone digits
        String digits = _phoneController.text.trim().replaceAll(RegExp(r'[\s\-]'), '');
        if (digits.startsWith('0')) {
          digits = digits.substring(1);
        }
        final formattedPhone = '$_selectedCountryCode$digits';

        await widget.onSave(
          _nameController.text.trim(),
          formattedPhone,
        );
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
        }
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
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextFormField(
                controller: _nameController,
                style: AppTextStyles.inputText,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                  hintText: 'Enter full name',
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 14),

            // Phone Number (Non-editable Country Code + Input)
            const Text('Phone Number', style: AppTextStyles.fieldLabel),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  // Country Code Dropdown (Non-editable inside text field)
                  PopupMenuButton<FlagModel>(
                    padding: EdgeInsets.zero,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (FlagModel item) {
                      setState(() {
                        _selectedCountryFlag = item.flag;
                        _selectedCountryCode = item.code;
                      });
                    },
                    itemBuilder: (context) => FlagData.flags.map((item) {
                      return PopupMenuItem<FlagModel>(
                        value: item,
                        child: Row(
                          children: [
                            Text(item.flag, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Text(
                              '${item.name} (${item.code})',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedCountryFlag, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 4),
                          Text(_selectedCountryCode, style: AppTextStyles.fieldLabel),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Divider between dropdown and input
                  Container(
                    width: 1.2,
                    height: 26,
                    color: AppColors.border,
                  ),

                  // Phone Digits Input (Digits Only)
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.inputText,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Enter phone number',
                        hintStyle: AppTextStyles.inputHint,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        final digits = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
                        if (digits.length < 7) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Email (Read-only / Managed by Firebase Auth)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email Address', style: AppTextStyles.fieldLabel),
                Text(
                  'Verified',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _emailController,
                enabled: false,
                style: AppTextStyles.inputText.copyWith(color: AppColors.textSecondary),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline_rounded, color: AppColors.textSecondary, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: AppTextStyles.buttonPrimary,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
