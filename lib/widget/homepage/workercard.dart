import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Workercard extends StatelessWidget {
  final String name;
  final String service;
  final String rating;
  final String? imageUrl;
  final String reviewCount;
  final String price;
  final String distance;
  const Workercard({
    super.key,
    required this.name,
    required this.service,
    required this.rating,
    this.imageUrl,
    required this.reviewCount,
    required this.price,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.surface,
      shadowColor: AppColors.darkBackground.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 0.8),
      ),
      child: Stack(
        children: [
          // ----------------------------------------------------
          // 1. MAIN CARD CONTENT
          // ----------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker Avatar Placeholder
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Image.asset(
                          imageUrl ?? 'assets/images/worker.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                        // TODO: Replace with Image.asset('assets/images/worker_1.png')
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Worker Info (Name, Title, Rating)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 65.0,
                        ), // Padding prevents overlap with top-right badge
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    style: AppTextStyles.h3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF0756A6),
                                  size: 17,
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(service, style: AppTextStyles.subtitleSmall),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: AppColors.star,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  rating,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '($reviewCount reviews)',
                                  style: AppTextStyles.subtitleSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 12),

                // Price & Request Quote Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starting Rate',
                          style: AppTextStyles.subtitleSmall,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Rs. $price/hr',
                          style: AppTextStyles.h2.copyWith(color: Colors.green),
                        ),
                      ],
                    ),

                    // Quote Action Button
                    _quoteButton(context),
                  ],
                ),
              ],
            ),
          ),

          // ----------------------------------------------------
          // 2. TOP-RIGHT DISTANCE BADGE (Positioned at Top Corner)
          // ----------------------------------------------------
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primarySoft, // Soft pastel blue tint
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.near_me_rounded,
                    size: 12,
                    color: AppColors.darkCard,
                  ),
                  SizedBox(width: 3),
                  Text(
                    distance,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkCard,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quoteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.push('/worker-profile');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Request Quote',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }
}
