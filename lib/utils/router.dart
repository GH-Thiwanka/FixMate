import 'package:fixmate/pages/customer/authscreens/forgrtpassword.dart';
import 'package:fixmate/pages/customer/authscreens/login.dart';
import 'package:fixmate/pages/customer/authscreens/otpverification.dart';
import 'package:fixmate/pages/customer/authscreens/signup.dart';
import 'package:fixmate/pages/homepage.dart';
import 'package:fixmate/pages/onboarding/onboarding.dart';
import 'package:fixmate/pages/onboarding/selection.dart';
import 'package:fixmate/pages/onboarding/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    //onboarding and splash screens
    GoRoute(path: '/splash', builder: (context, state) => const Splash()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      path: '/selection',
      builder: (context, state) => const SelectionPage(),
    ),

    //auth screens
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
  ],
);
