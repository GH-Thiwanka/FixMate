import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class WorkerReviewsTab extends StatelessWidget {
  const WorkerReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 4,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.divider, height: 24),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primarySoft,
                  child: Text(
                    'U${index + 1}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kasun Jayawardena',
                        style: AppTextStyles.h3.copyWith(fontSize: 14.5),
                      ),
                      const Text(
                        '2 days ago',
                        style: AppTextStyles.subtitleSmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => const Icon(
                      Icons.star_rounded,
                      color: AppColors.star,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Chaminda was very punctual and fixed our complete circuit breaker issue in under an hour. Very clean work!',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
