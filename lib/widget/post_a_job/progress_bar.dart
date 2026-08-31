import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class PostJobProgressBar extends StatelessWidget {
  final int currentStep;
  final String stepTitle;

  const PostJobProgressBar({
    super.key,
    required this.currentStep,
    required this.stepTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of 5',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(stepTitle, style: AppTextStyles.subtitleSmall),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              final isCompleted = index <= currentStep;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 4 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
