import 'package:fixmate/model/category_model.dart';
import 'package:fixmate/widget/category_icon.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class Step1SelectServiceWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final String selectedSubService;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onSubServiceSelected;

  const Step1SelectServiceWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSubService,
    required this.onCategorySelected,
    required this.onSubServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentCategoryModel = categories.firstWhere(
      (c) => c.title == selectedCategory,
      orElse: () => categories.isNotEmpty
          ? categories.first
          : CategoryModel(
              id: '',
              title: '',
              imageUrl: '',
              color: Colors.transparent,
            ),
    );

    final currentSubServices = currentCategoryModel.subServices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Category', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = selectedCategory == cat.title;
            return InkWell(
              onTap: () => onCategorySelected(cat.title),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryLight.withOpacity(0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryIconWidget(
                      imageUrl: cat.imageUrl,
                      width: 38,
                      height: 38,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.title,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text('Select Specific Service', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        if (currentSubServices.isEmpty)
          const Text(
            'No specific services available for this category.',
            style: AppTextStyles.subtitleSmall,
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: currentSubServices.map((sub) {
              final isSelected = selectedSubService == sub;
              return ChoiceChip(
                label: Text(sub),
                selected: isSelected,
                selectedColor: AppColors.primarySoft,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                onSelected: (val) {
                  if (val) onSubServiceSelected(sub);
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}
