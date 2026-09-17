import 'package:fixmate/data/populerservicedata.dart';
import 'package:fixmate/data/worker_data.dart';
import 'package:fixmate/service/location.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/bottumnavbar.dart';
import 'package:fixmate/widget/homepage/filterbottomsheet.dart';
import 'package:fixmate/widget/homepage/notificationwidget.dart';
import 'package:fixmate/widget/homepage/postjobcontainer.dart';
import 'package:fixmate/widget/homepage/workercard.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final workerdata = WorkerData();

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
        _currentAddress = address;
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
          padding: const EdgeInsets.all(10),
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

                      // User Avatar (Screen #33 Profile)
                      InkWell(
                        onTap: () {
                          context.go('/profile');
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
                          child: ClipOval(
                            child: FirebaseAuth.instance.currentUser?.photoURL != null
                                ? Image.network(
                                    FirebaseAuth.instance.currentUser!.photoURL!,
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.person_rounded,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Postjobcontainer(),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Popular Services', style: AppTextStyles.h2),
                  GestureDetector(
                    onTap: () {
                      context.push('/all-categories');
                    },
                    child: const Text('See All', style: AppTextStyles.link),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                      context.push('/explore', extra: {'title': service.title});
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryLight.withOpacity(0.4),
                          width: 1,
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
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Top Rated Near You', style: AppTextStyles.h2),
                  GestureDetector(
                    onTap: () {
                      context.push('/explore');
                    },
                    child: const Text('Explore', style: AppTextStyles.link),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Horizontal Scrolling Worker Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    for (var worker in workerdata.workers.take(4))
                      SizedBox(
                        width: 350,
                        child: Workercard(
                          name: worker.name,
                          service: worker.service,
                          imageUrl: worker.imageUrl,
                          rating: worker.rating,
                          reviewCount: worker.reviewCount,
                          price: worker.price,
                          distance: worker.distance,
                        ),
                      ),
                  ],
                ),
              ),
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
