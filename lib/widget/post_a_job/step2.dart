import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class Step2ProjectDetailsWidget extends StatelessWidget {
  final TextEditingController descriptionController;
  final String selectedPropertyType;
  final ValueChanged<String> onPropertyTypeChanged;

  const Step2ProjectDetailsWidget({
    super.key,
    required this.descriptionController,
    required this.selectedPropertyType,
    required this.onPropertyTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Describe Your Job', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        TextField(
          controller: descriptionController,
          maxLines: 4,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: 'e.g. Need complete painting for 2 bedrooms and living room. Walls require minor crack repair...',
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text('Property Type', style: AppTextStyles.h3),
        const SizedBox(height: 10),
        Row(
          children: ['House', 'Apartment', 'Commercial'].map((type) {
            final isSelected = selectedPropertyType == type;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => onPropertyTypeChanged(type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primarySoft
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        const Text(
          'Upload Photos / Videos (Optional)',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.primary,
                    size: 26,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
