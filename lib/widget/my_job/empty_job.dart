import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyJobsWidget extends StatelessWidget {
  final JobTabType tab;

  const EmptyJobsWidget({super.key, required this.tab});

  String get _title {
    switch (tab) {
      case JobTabType.active:
        return 'No Active Jobs';
      case JobTabType.upcoming:
        return 'No Upcoming Bookings';
      case JobTabType.completed:
        return 'No Finished Jobs Yet';
      case JobTabType.cancelled:
        return 'No Cancellations';
    }
  }

  String get _subtitle {
    switch (tab) {
      case JobTabType.active:
        return 'Post a job to get competitive quotes from top rated workers near you.';
      case JobTabType.upcoming:
        return 'You have no scheduled visits booked at this time.';
      case JobTabType.completed:
        return 'Your completed service history and receipts will appear here.';
      case JobTabType.cancelled:
        return 'You do not have any cancelled service requests.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 52,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(_title, style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              _subtitle,
              style: AppTextStyles.subtitleSmall,
              textAlign: TextAlign.center,
            ),
            if (tab == JobTabType.active) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 180,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/post-a-job');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Post a Job',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
