import 'package:fixmate/data/populerservicedata.dart';
import 'package:fixmate/service/location.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/bottumnavbar.dart';
import 'package:fixmate/widget/homepage/filterbottomsheet.dart';
import 'package:fixmate/widget/homepage/notificationwidget.dart';
import 'package:fixmate/widget/homepage/postjobcontainer.dart';
import 'package:fixmate/widget/homepage/workercard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  String _currentAddress = 'Detecting location...';
  bool _isLoadingLocation = true;
  final populerservicedata = Populerservicedata();

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    setState(() => _isLoadingLocation = true);
    final address = await LocationService.getCurrentAddress();
    if (mounted) {
      setState(() {
        _currentAddress = address ?? 'Colombo, Sri Lanka';
        _isLoadingLocation = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // 1. TOP BAR (Address Selector, Notification Bell & Avatar)
              // ==============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Location Address Selector
                  GestureDetector(
                    onTap: _fetchUserLocation,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Location',
                              style: AppTextStyles.subtitleSmall,
                            ),
                            const SizedBox(height: 2),
                            _isLoadingLocation
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _currentAddress,
                                    style: AppTextStyles.fieldLabel.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),

                  // Actions: Notifications & Profile
                  Row(
                    children: [
                      // Notification Bell with Badge (Screen #31)
                      const Notificationwidget(),
                      const SizedBox(width: 6),

                      // User Avatar Placeholder (Screen #33 Profile)
                      InkWell(
                        onTap: () {
                          // TODO: context.push('/profile');
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                            // TODO: Replace with Image.asset('assets/images/user_avatar.png')
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. SEARCH & FILTER BAR
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: AppTextStyles.inputText,
                        decoration: const InputDecoration(
                          hintText:
                              'Search painters, plumbers, electricians...',
                          hintStyle: AppTextStyles.inputHint,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.textLight,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Filter Button

                  // Inside your filter icon onTap:
                  InkWell(
                    onTap: () {
                      FilterBottomSheet.show(
                        context,
                        onApply: () {
                          print('Filters applied!');
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Postjobcontainer(),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Popular Services', style: AppTextStyles.h2),
                  TextButton(
                    onPressed: () {
                      // TODO: context.push('/all-categories');
                    },
                    child: const Text('See All', style: AppTextStyles.link),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemCount: populerservicedata.populerservice.length,
                itemBuilder: (context, index) {
                  final service = populerservicedata.populerservice[index];
                  return InkWell(
                    onTap: () {
                      // TODO: Navigate to Category Results (Screen #11)
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.electrician,
                          width: 0.2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 6),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: service.color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                service.image,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.title,
                            style: AppTextStyles.fieldLabel.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Top Rated Near You', style: AppTextStyles.h2),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to Explore screen
                    },
                    child: const Text('Explore', style: AppTextStyles.link),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Worker Card Item
              const Workercard(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // ==============================================================
      // 6. PERSISTENT 5-TAB BOTTOM NAVIGATION BAR (Flow 3)
      // ==============================================================
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });

          // Example: Navigate using GoRouter or switch screens
          switch (index) {
            case 0:
              // Already on Home
              break;
            case 1:
              // context.go('/explore');
              break;
            case 2:
              // context.go('/my-jobs');
              break;
            case 3:
              // context.go('/messages');
              break;
            case 4:
              // context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}
