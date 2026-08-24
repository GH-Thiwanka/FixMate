import 'package:fixmate/pages/customer/authscreens/login.dart';
import 'package:fixmate/pages/customer/authscreens/signup.dart';
import 'package:fixmate/pages/homepage.dart';
import 'package:fixmate/pages/onboarding/onboarding.dart';
import 'package:fixmate/pages/onboarding/selection.dart';
import 'package:fixmate/pages/onboarding/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const Splash()),
    GoRoute(path: '/home', builder: (context, state) => const Homepage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      path: '/selection',
      builder: (context, state) => const SelectionPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
  ],
);
