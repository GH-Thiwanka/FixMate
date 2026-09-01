import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class WorkerProfileHeader extends StatelessWidget {
  final String name;
  final String profession;
  final double rating;
  final int reviewCount;
  final String experience;
  final String completedJobs;

  const WorkerProfileHeader({
    super.key,
    required this.name,
    required this.profession,
    this.rating = 4.9,
    this.reviewCount = 124,
    this.experience = '8+ Years Exp',
    this.completedJobs = '230+ Done',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Placeholder
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                size: 50,
                color: AppColors.primary,
              ),
              // TODO: Replace with Image.asset('assets/images/worker_1.png')
            ),
          ),
          const SizedBox(width: 16),

          // Worker Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: AppTextStyles.h1.copyWith(fontSize: 22),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF0756A6),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(profession, style: AppTextStyles.subtitle),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.star,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviewCount reviews)',
                      style: AppTextStyles.subtitleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Badges Row
                Wrap(
                  spacing: 8,
                  children: [
                    _buildBadge(Icons.workspace_premium_rounded, experience),
                    _buildBadge(Icons.task_alt_rounded, completedJobs),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.acRepair.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
