import 'package:fixmate/data/worker_data.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/homepage/filterbottomsheet.dart';
import 'package:fixmate/widget/homepage/workercard.dart';
import 'package:flutter/material.dart';

class CategoryResultsScreen extends StatefulWidget {
  final String categoryTitle;

  const CategoryResultsScreen({super.key, required this.categoryTitle});

  @override
  State<CategoryResultsScreen> createState() => _CategoryResultsScreenState();
}

class _CategoryResultsScreenState extends State<CategoryResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterChipIndex = 0;

  final WorkerData _workerData = WorkerData();

  final List<String> _filterChips = [
    'All',
    '★ 4.5+ Rated',
    'Near Me (<3km)',
    'Available Today',
    'Verified Only',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.categoryTitle,
              style: AppTextStyles.h2.copyWith(fontSize: 18),
            ),
            const Text(
              'Verified professionals nearby',
              style: AppTextStyles.subtitleSmall,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar & Filter Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: AppTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText: 'Search in ${widget.categoryTitle}...',
                          hintStyle: AppTextStyles.inputHint,
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textLight,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Filter Button
                  InkWell(
                    onTap: () {
                      FilterBottomSheet.show(context);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Horizontal Filter / Sort Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: List.generate(_filterChips.length, (index) {
                  final isSelected = _selectedFilterChipIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_filterChips[index]),
                      selected: isSelected,
                      selectedColor: AppColors.primarySoft,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 12.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilterChipIndex = index);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),

            // 3. Worker Results Feed (Using your Workercard)
            const SizedBox(height: 16),
            // Add your worker results feed here
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _workerData.workers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Workercard(
                      name: _workerData.workers[index].name,
                      service: _workerData.workers[index].service,
                      rating: _workerData.workers[index].rating,
                      price: _workerData.workers[index].price,
                      distance: _workerData.workers[index].distance,
                      reviewCount: _workerData.workers[index].reviewCount,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
