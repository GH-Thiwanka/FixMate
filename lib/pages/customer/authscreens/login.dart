import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/auth_and_onboarding/googlesignup.dart';
import 'package:fixmate/widget/auth_and_onboarding/submilbutton.dart';
import 'package:fixmate/widget/auth_and_onboarding/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height < 720 ? 720 : size.height,
          child: Stack(
            children: [
              // ----------------------------------------------------
              // 1. TOP BACKGROUND IMAGE
              // ----------------------------------------------------
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height * 0.38,
                child: Image.asset(
                  'assets/images/loginback.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned(
                top: 30,
                left: 5,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.textPrimary,
                  onPressed: () {
                    context.go('/selection');
                  },
                ),
              ),

              // ----------------------------------------------------
              // 2. BOTTOM WHITE SHEET (Login Form)
              // ----------------------------------------------------
              Positioned(
                top: size.height * 0.32,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 28.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Welcome Back! 👋"
                          Row(
                            children: const [
                              Text('Welcome Back! ', style: AppTextStyles.h1),
                              Text('👋', style: TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Login to continue',
                            style: AppTextStyles.subtitle,
                          ),
                          const SizedBox(height: 22),

                          // Email or Phone Number Field
                          const Text(
                            'Email or Phone Number',
                            style: AppTextStyles.fieldLabel,
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _identifierController,
                            inputType: TextInputType.emailAddress,
                            hintText: 'Enter email or phone number',
                            prefixIcon: Icons.smartphone_rounded,
                            validatorText:
                                'Please enter your email or phone number',
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          const Text(
                            'Password',
                            style: AppTextStyles.fieldLabel,
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            isPasswordField: true,
                            validatorText: 'Please enter your password',
                          ),

                          // Forgot Password? Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                context.push('/forgot-password');
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTextStyles.link,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Login Button
                          Submilbutton(
                            buttonText: 'Login',
                            handleSubmit: _handleLogin,
                          ),
                          const SizedBox(height: 18),

                          // "OR" Divider
                          Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: AppColors.border,
                                  thickness: 1.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.0),
                                child: Text(
                                  'OR',
                                  style: AppTextStyles.dividerOr,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.border,
                                  thickness: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // "Continue with Google" Button
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

                          const Spacer(),

                          // Footer Sign-Up Link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: AppTextStyles.linkPrefix,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push('/signup');
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: AppTextStyles.link,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
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
