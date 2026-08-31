import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class WorkerPortfolioTab extends StatelessWidget {
  final int itemCount;

  const WorkerPortfolioTab({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // TODO: Open Full Screen Image Viewer (Screen #14 in PDF)
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_outlined,
                    color: AppColors.textLight,
                    size: 32,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Project Photo ${index + 1}',
                    style: AppTextStyles.subtitleSmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
