import 'package:fixmate/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/onboarding_data.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  double _page = 0;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final data = OnboardingData.onboardingData;

    if (_currentPage < data.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/selection');
    }
  }

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final page = _pageController.page ?? 0;

      setState(() {
        _page = page;
        _currentPage = page.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = OnboardingData.onboardingData;
    final item = data[_currentPage];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND IMAGE CHANGES
          PageView.builder(
            controller: _pageController,
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Image.asset(data[index].image, fit: BoxFit.cover);
            },
          ),

          // FIXED GRADIENT
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.05),
                  Colors.transparent,
                  AppColors.primaryDark.withOpacity(0.20),
                  AppColors.primaryLight.withOpacity(0.88),
                ],
                stops: const [0.0, 0.35, 0.55, 1.0],
              ),
            ),
          ),

          // FIXED CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ---------------- TITLE ----------------
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        data[_currentPage].title,
                        key: ValueKey(data[_currentPage].title),
                        style: const TextStyle(
                          color: Color(0xffFFF8F0),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ------------- DESCRIPTION -------------
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        data[_currentPage].description,
                        key: ValueKey(data[_currentPage].description),
                        style: const TextStyle(
                          color: Color(0xffF5E8DA),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ------------ PAGE INDICATOR -----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(data.length, (index) {
                      final active = index == _currentPage;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? AppColors.surface : Color(0xffD9B79A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // ---------------- BUTTON ----------------
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFFFDF9),
                        foregroundColor: Color(0xff3A281F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentPage == data.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
