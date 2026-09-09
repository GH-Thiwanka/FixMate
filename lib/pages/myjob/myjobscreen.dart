import 'package:fixmate/data/job_data.dart';
import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/bottumnavbar.dart';
import 'package:fixmate/widget/my_job/empty_job.dart';
import 'package:fixmate/widget/my_job/job_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedBottomNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<JobModel> _getJobsForTab(JobTabType tab) {
    return MyJobsData.jobs.where((job) => job.tab == tab).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _getJobsForTab(JobTabType.active).length;
    final upcomingCount = _getJobsForTab(JobTabType.upcoming).length;
    final completedCount = _getJobsForTab(JobTabType.completed).length;
    final cancelledCount = _getJobsForTab(JobTabType.cancelled).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/post-a-job'),

        backgroundColor: AppColors.surface,
        child: const Icon(Icons.add_rounded, color: AppColors.primary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // 1. CUSTOM 4-TAB SEGMENTED BAR
            // ----------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.all(3),
                tabs: [
                  Tab(text: 'Active ($activeCount)'),
                  Tab(text: 'Upcoming ($upcomingCount)'),
                  Tab(text: 'Done ($completedCount)'),
                  Tab(text: 'Cancelled ($cancelledCount)'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ----------------------------------------------------
            // 2. TAB VIEWS (Active, Upcoming, Completed, Cancelled)
            // ----------------------------------------------------
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildJobList(JobTabType.active),
                  _buildJobList(JobTabType.upcoming),
                  _buildJobList(JobTabType.completed),
                  _buildJobList(JobTabType.cancelled),
                ],
              ),
            ),
          ],
        ),
      ),

      // ----------------------------------------------------
      // 3. PERSISTENT 5-TAB BOTTOM NAVIGATION BAR
      // ----------------------------------------------------
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

  Widget _buildJobList(JobTabType tab) {
    final jobList = _getJobsForTab(tab);

    if (jobList.isEmpty) {
      return EmptyJobsWidget(tab: tab);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: jobList.length,
      itemBuilder: (context, index) {
        return JobCard(job: jobList[index]);
      },
    );
  }
}
