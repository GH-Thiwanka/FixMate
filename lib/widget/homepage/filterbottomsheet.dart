import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final VoidCallback? onApply;
  final VoidCallback? onReset;

  const FilterBottomSheet({super.key, this.onApply, this.onReset});

  /// Static helper to open the bottom sheet from anywhere with 1 line:
  /// FilterBottomSheet.show(context);
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onApply,
    VoidCallback? onReset,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) =>
          FilterBottomSheet(onApply: onApply, onReset: onReset),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Selected filter states
  String _selectedSortBy = 'Top Rated';
  String _selectedPriceRange = 'All';
  bool _verifiedOnly = true;
  bool _availableToday = false;

  final List<String> _sortOptions = [
    'Top Rated',
    'Nearest First',
    'Price: Low to High',
    'Price: High to Low',
  ];

  final List<String> _priceOptions = [
    'All',
    'Under Rs. 2,000',
    'Rs. 2,000 - 5,000',
    'Rs. 5,000+',
  ];

  void _handleReset() {
    setState(() {
      _selectedSortBy = 'Top Rated';
      _selectedPriceRange = 'All';
      _verifiedOnly = true;
      _availableToday = false;
    });
    widget.onReset?.call();
  }

  void _handleApply() {
    Navigator.pop(context);
    widget.onApply?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 12.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2. Header (Title, Reset & Close Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter & Sort', style: AppTextStyles.h2),
              Row(
                children: [
                  TextButton(
                    onPressed: _handleReset,
                    child: const Text('Reset', style: AppTextStyles.link),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Sort By Section
          const Text('Sort By', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sortOptions.map((option) {
              final isSelected = _selectedSortBy == option;
              return _buildChoiceChip(
                label: option,
                isSelected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedSortBy = option);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 4. Price Range Section
          const Text('Price Range', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _priceOptions.map((range) {
              final isSelected = _selectedPriceRange == range;
              return _buildChoiceChip(
                label: range,
                isSelected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedPriceRange = range);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 5. Additional Toggles
          const Text('Worker Preferences', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Verified Workers Only',
              style: AppTextStyles.bodyMedium,
            ),
            value: _verifiedOnly,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _verifiedOnly = val),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Available Today',
              style: AppTextStyles.bodyMedium,
            ),
            value: _availableToday,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _availableToday = val),
          ),
          const SizedBox(height: 24),

          // 6. "Apply Filters" Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _handleApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: AppTextStyles.buttonPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primarySoft,
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.4 : 1.0,
        ),
      ),
      onSelected: onSelected,
    );
  }
}
