import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class Workercard extends StatelessWidget {
  const Workercard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                  // TODO: Replace with Image.asset('assets/images/worker_1.png')
                ),
              ),
              const SizedBox(width: 14),

              // Worker Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('Chaminda Silva', style: AppTextStyles.h3),
                        SizedBox(width: 6),
                        Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF0756A6),
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Master Electrician',
                      style: AppTextStyles.subtitleSmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.star,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(124 reviews)',
                          style: AppTextStyles.subtitleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 10),

          // Price, Distance & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Rs. 2,500/hr',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text('1.8 km away', style: AppTextStyles.subtitleSmall),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: context.push('/request-quote');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Request Quote',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
