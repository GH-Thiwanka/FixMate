import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class WorkerOverviewTab extends StatelessWidget {
  final String bio;
  final List<String> skills;

  const WorkerOverviewTab({
    super.key,
    this.bio = 'Certified master electrician with over 8 years of experience in residential, commercial, and industrial electrical installations. Specializing in safe full-house wiring, fuse box upgrades, and solar power maintenance.',
    this.skills = const [
      'House Wiring',
      'Circuit Repair',
      'Solar Setup',
      'Appliance Repair',
      'Lighting Design',
      'Fuse Box Replacement',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Me
          const Text('About Me', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            bio,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 22),

          // Skills & Specializations
          const Text('Skills & Specializations', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(70),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),

          // Verified Credentials
          const Text('Verified Credentials', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: AppColors.success,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Govt. Certified Electrician',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ID & Police Background Checked',
                        style: AppTextStyles.subtitleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
