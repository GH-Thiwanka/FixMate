import 'package:fixmate/widget/bottumnavbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});
  final int _selectedBottomNavIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Profile Screen')),
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
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}
