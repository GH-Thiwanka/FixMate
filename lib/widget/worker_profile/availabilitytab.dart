import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class WorkerAvailabilityTab extends StatelessWidget {
  const WorkerAvailabilityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Working Hours', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          const Text(
            'Monday – Saturday: 8:00 AM – 6:00 PM',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          const Text('Available Slots This Week', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          _buildSlotTile('Today', '2 slots remaining (Afternoon)', true),
          const SizedBox(height: 10),
          _buildSlotTile(
            'Tomorrow',
            '4 slots remaining (Morning & Afternoon)',
            true,
          ),
          const SizedBox(height: 10),
          _buildSlotTile('Friday', 'Fully booked', false),
        ],
      ),
    );
  }

  Widget _buildSlotTile(String day, String info, bool available) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: available ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: available ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: available
                      ? const Color(0xFF166534)
                      : const Color(0xFF991B1B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                info,
                style: TextStyle(
                  fontSize: 12.5,
                  color: available
                      ? const Color(0xFF15803D)
                      : const Color(0xFFB91C1C),
                ),
              ),
            ],
          ),
          Icon(
            available ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: available ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );
  }
}
