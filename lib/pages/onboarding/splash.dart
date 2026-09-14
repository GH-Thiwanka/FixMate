import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade Animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Scale Animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Start animation
    _controller.forward();

    // Check Firebase Auth state after animation completes
    _checkAuthStateAndNavigate();
  }

  Future<void> _checkAuthStateAndNavigate() async {
    // Show splash animation for 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Refresh token & verification status
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (!mounted) return;
        if (refreshedUser != null && refreshedUser.emailVerified) {
          // Logged in & Verified -> Go directly to Home Dashboard
          context.go('/');
          return;
        }
      } catch (e) {
        if (!mounted) return;
        // In case network was unavailable, check cached state
        if (user.emailVerified) {
          context.go('/');
          return;
        }
      }
    }

    if (!mounted) return;
    // Not logged in or unverified -> Navigate to Onboarding Screen
    context.go('/onboarding');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  child: Image(image: AssetImage('assets/icons/logo.png')),
                ),
                SizedBox(
                  height: 50,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Fix',
                          style: AppTextStyles.h1.copyWith(fontSize: 40),
                        ),
                        TextSpan(
                          text: 'Mate',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
