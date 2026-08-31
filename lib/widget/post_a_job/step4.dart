import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class Step4SetBudgetWidget extends StatelessWidget {
  final String budgetPreference;
  final double budgetAmount;
  final ValueChanged<String> onBudgetPreferenceChanged;
  final ValueChanged<double> onBudgetAmountChanged;

  const Step4SetBudgetWidget({
    super.key,
    required this.budgetPreference,
    required this.budgetAmount,
    required this.onBudgetPreferenceChanged,
    required this.onBudgetAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Budget Preference', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildChoiceCard(
                'I Need Quotes\n(Workers Estimate)',
                Icons.request_quote_outlined,
                budgetPreference == 'I Need Quotes',
                () => onBudgetPreferenceChanged('I Need Quotes'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceCard(
                'I Have Fixed\nBudget',
                Icons.account_balance_wallet_outlined,
                budgetPreference == 'Fixed Budget',
                () => onBudgetPreferenceChanged('Fixed Budget'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        if (budgetPreference == 'Fixed Budget') ...[
          Text(
            'Your Budget: Rs. ${budgetAmount.toInt().toString()}',
            style: AppTextStyles.h3,
          ),
          Slider(
            value: budgetAmount,
            min: 2000,
            max: 100000,
            divisions: 49,
            activeColor: AppColors.primary,
            onChanged: onBudgetAmountChanged,
          ),
        ],
      ],
    );
  }

  Widget _buildChoiceCard(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
