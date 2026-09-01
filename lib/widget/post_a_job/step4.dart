import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class Step4SetBudgetWidget extends StatelessWidget {
  final String budgetPreference;
  final TextEditingController budgetController;
  final ValueChanged<String> onBudgetPreferenceChanged;

  const Step4SetBudgetWidget({
    super.key,
    required this.budgetPreference,
    required this.budgetController,
    required this.onBudgetPreferenceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Budget Preference', style: AppTextStyles.h3),
        const SizedBox(height: 12),

        // Choice Cards: "I Need Quotes" vs "I Have Fixed Budget"
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

        // ----------------------------------------------------
        // FIXED BUDGET TEXTFIELD & PRESET CHIPS
        // ----------------------------------------------------
        if (budgetPreference == 'Fixed Budget') ...[
          const Text('Your Estimated Budget (LKR)', style: AppTextStyles.h3),
          const SizedBox(height: 12),

          // Custom Amount Input Field
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Text(
                    'Rs. ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                hintText: 'Enter amount (e.g. 15,000)',
                hintStyle: AppTextStyles.inputHint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: AppColors.primaryLight),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Preset Suggestion Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [5000, 15000, 10000, 25000, 50000].map((amount) {
              return ActionChip(
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                label: Text(
                  'Rs. $amount',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                onPressed: () {
                  budgetController.text = amount.toString();
                },
              );
            }).toList(),
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
          color: isSelected ? AppColors.primarySoft : AppColors.surface,
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
