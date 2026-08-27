import 'package:fixmate/theme/colors.dart';
import 'package:go_router/go_router.dart';

import 'package:fixmate/widget/auth_and_onboarding/selectionWidget.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 15), // Add some space at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fix',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Mate',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SelectionWidget(
              imagePath: 'assets/icons/home.png',
              title: 'I need a worker',
              description: 'Find verified professionals for your home maintenance needs.',
              onTap: () {
                context.go('/login');
              },
            ),
            SelectionWidget(
              imagePath: 'assets/icons/worker.png',
              title: 'I\'m a worker',
              description:
                  'Join the network, find jobs, and manage your schedule.',
              onTap: () {
                context.go('/onboarding');
              },
            ),
            const SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
