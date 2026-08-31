import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/widget/worker_profile/availabilitytab.dart';
import 'package:fixmate/widget/worker_profile/bottumactionbar.dart';
import 'package:fixmate/widget/worker_profile/overviewtab.dart';
import 'package:fixmate/widget/worker_profile/profileheader.dart';
import 'package:fixmate/widget/worker_profile/protfoliotab.dart';
import 'package:fixmate/widget/worker_profile/reviwestab.dart';
import 'package:fixmate/widget/worker_profile/servicetab.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class WorkerProfileScreen extends StatefulWidget {
  final String workerName;
  final String profession;

  const WorkerProfileScreen({
    super.key,
    this.workerName = 'Chaminda Silva',
    this.profession = 'Master Electrician',
  });

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.orange[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: AppColors.textPrimary,
                ),
                onPressed: () async {
                  // Find the button position for iPad / Tablet compatibility
                  final box = context.findRenderObject() as RenderBox?;
                  final position = box != null
                      ? box.localToGlobal(Offset.zero) & box.size
                      : null;
                  // Message to share
                  final String shareText =
                      'Check out ${widget.workerName} (${widget.profession}) on FixMate!\n'
                      '⭐ Rated 4.9 (124 reviews)\n'
                      'Book verified renovation & repair services here: https://fixmate.app/workers/chaminda-silva';
                  await Share.share(
                    shareText,
                    subject: 'Hire ${widget.workerName} on FixMate',
                    sharePositionOrigin: position,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.primary : AppColors.textPrimary,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 1. Profile Header
          WorkerProfileHeader(
            name: widget.workerName,
            profession: widget.profession,
          ),

          // 2. Tab Bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3.0,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Portfolio'),
              Tab(text: 'Reviews'),
              Tab(text: 'Services'),
              Tab(text: 'Availability'),
            ],
          ),

          // 3. Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                WorkerOverviewTab(),
                WorkerPortfolioTab(),
                WorkerReviewsTab(),
                WorkerServicesTab(),
                WorkerAvailabilityTab(),
              ],
            ),
          ),

          // 4. Sticky Bottom Action Bar
          WorkerBottomActionBar(
            onChatPressed: () {
              // TODO: Navigate to Worker Chat Screen (Screen #28)
            },
            onRequestQuotePressed: () {
              // TODO: Navigate to Create Job Flow (Screen #15)
            },
          ),
        ],
      ),
    );
  }
}
