import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class Step5ReviewPostWidget extends StatelessWidget {
  final String category;
  final String subService;
  final String propertyType;
  final String location;
  final String schedule;
  final String budget;
  final bool broadcastToAll;
  final ValueChanged<bool> onBroadcastChanged;

  const Step5ReviewPostWidget({
    super.key,
    required this.category,
    required this.subService,
    required this.propertyType,
    required this.location,
    required this.schedule,
    required this.budget,
    required this.broadcastToAll,
    required this.onBroadcastChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Job Summary', style: AppTextStyles.h2),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Category', '$category ($subService)'),
              const Divider(color: AppColors.divider),
              _buildSummaryRow('Property', propertyType),
              const Divider(color: AppColors.divider),
              _buildSummaryRow('Location', location),
              const Divider(color: AppColors.divider),
              _buildSummaryRow('Schedule', schedule),
              const Divider(color: AppColors.divider),
              _buildSummaryRow('Budget', budget),
            ],
          ),
        ),
        const SizedBox(height: 20),

        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Post publicly to verified workers',
            style: AppTextStyles.fieldLabel,
          ),
          subtitle: const Text(
            'Receive multiple quotes from top-rated pros in your area',
            style: AppTextStyles.subtitleSmall,
          ),
          value: broadcastToAll,
          activeColor: AppColors.primary,
          onChanged: onBroadcastChanged,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.subtitleSmall),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.fieldLabel,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
