import 'package:fixmate/data/flag_data.dart';
import 'package:fixmate/model/flag_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/auth_and_onboarding/googlesignup.dart';
import 'package:fixmate/widget/auth_and_onboarding/submilbutton.dart';
import 'package:fixmate/widget/auth_and_onboarding/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreeToTerms = true;

  // Selected Country Code & Flag initialized from FlagData
  late String _selectedCountryCode;
  late String _selectedCountryFlag;

  // Password validation checks
  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasNumberAndSymbol =>
      RegExp(r'[0-9]').hasMatch(_passwordController.text) &&
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);

  @override
  void initState() {
    super.initState();
    if (FlagData.flags.isNotEmpty) {
      _selectedCountryCode = FlagData.flags.first.code;
      _selectedCountryFlag = FlagData.flags.first.flag;
    } else {
      _selectedCountryCode = '+94';
      _selectedCountryFlag = '🇱🇰';
    }

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (!_agreeToTerms) {
      context.go('/');

      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Creating account for ${_fullNameController.text}...'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER SECTION (Title, Subtitle & Badge)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Create ',
                                  style: AppTextStyles.h1,
                                ),
                                TextSpan(
                                  text: 'Account',
                                  style: AppTextStyles.h1Primary,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Join FixMate and get things done!',
                            style: AppTextStyles.subtitle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // ID / Registration Badge Graphic
                    Image.asset(
                      'assets/icons/noted.png',
                      width: 70,
                      height: 70,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. FULL NAME FIELD
                const Text('Full Name', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline_rounded,
                  validatorText: 'Please enter your full name',
                ),
                const SizedBox(height: 16),

                // 3. EMAIL FIELD
                const Text('Email', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. PHONE NUMBER (Country Code Selector + Input)
                const Text('Phone Number', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      // Country Code Dropdown
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
                                Text(
                                  item.flag,
                                  style: const TextStyle(fontSize: 18),
                                ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 14.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCountryFlag,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _selectedCountryCode,
                                style: AppTextStyles.fieldLabel,
                              ),
                              const SizedBox(width: 4),
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
                        height: 28,
                        color: AppColors.border,
                      ),

                      // Phone Input
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: AppTextStyles.inputText,
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            hintStyle: AppTextStyles.inputHint,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            isDense: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 5. PASSWORD FIELD (with automatic eye toggle)
                const Text('Password', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Create a password',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPasswordField: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // 6. PASSWORD REQUIREMENTS CHECKLIST
                _PasswordRequirementItem(
                  text: 'At least 8 characters',
                  isValid: _hasMinLength,
                ),
                const SizedBox(height: 6),
                _PasswordRequirementItem(
                  text: 'Include number and symbol',
                  isValid: _hasNumberAndSymbol,
                ),
                const SizedBox(height: 6),
                _PasswordRequirementItem(
                  text: 'Must contain uppercase letter',
                  isValid: _hasUppercase,
                ),
                const SizedBox(height: 16),

                // 7. TERMS OF SERVICE CHECKBOX
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeToTerms,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _agreeToTerms = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: AppTextStyles.subtitleSmall,
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // 8. "CREATE ACCOUNT" BUTTON
                Submilbutton(
                  buttonText: 'Create Account',
                  handleSubmit: _handleSignUp,
                ),
                const SizedBox(height: 18),

                // 9. "OR" DIVIDER
                Row(
                  children: const [
                    Expanded(
                      child: Divider(color: AppColors.border, thickness: 1.2),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      child: Text('OR', style: AppTextStyles.dividerOr),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.border, thickness: 1.2),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 10. "CONTINUE WITH GOOGLE" BUTTON
                GoogleSignInButton(
                  onSuccess: (account) {
                    print(
                      'Selected User: ${account.displayName} (${account.email})',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Welcome, ${account.displayName ?? account.email}!',
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  onError: (error) {
                    print('Google Sign-In Error: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign in failed: $error'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 11. FOOTER ("Already have an account? Login")
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: AppTextStyles.linkPrefix,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Login', style: AppTextStyles.link),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HELPER WIDGETS
// ---------------------------------------------------------------------------

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
          size: 16,
          color: isValid ? AppColors.success : AppColors.textLight,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.subtitleSmall.copyWith(
            color: isValid ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isValid ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
