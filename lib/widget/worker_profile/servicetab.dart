import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class WorkerServicesTab extends StatelessWidget {
  final List<Map<String, String>> services;

  const WorkerServicesTab({
    super.key,
    this.services = const [
      {'name': 'Full House Inspection', 'price': 'Rs. 3,500/hr'},
      {'name': 'Ceiling Fan Installation', 'price': 'Rs. 1,500/hr'},
      {'name': 'Circuit Breaker Repair', 'price': 'Rs. 2,500/hr'},
      {'name': 'Solar Inverter Setup', 'price': 'Rs. 6,000/hr'},
      {'name': 'Hourly Labour Rate', 'price': 'Rs. 2,500/hr'},
    ],
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = services[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['name']!, style: AppTextStyles.fieldLabel),
              Text(
                item['price']!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
