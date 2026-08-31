import 'package:fixmate/data/worker_data.dart';
import 'package:fixmate/model/worker_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/homepage/filterbottomsheet.dart';
import 'package:fixmate/widget/homepage/workercard.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  final String title;

  const ExploreScreen({super.key, this.title = 'Top Rated Near You'});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterChipIndex = 0;
  final WorkerData workerData = WorkerData();
  String _searchQuery = '';

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
    // 1. Filter workers dynamically by search query (Name or Service)
    final List<WorkerModel> filteredWorkers = workerData.workers.where((
      worker,
    ) {
      final query = _searchQuery.toLowerCase();
      final nameMatches = worker.name.toLowerCase().contains(query);
      final serviceMatches = worker.service.toLowerCase().contains(query);
      return nameMatches || serviceMatches;
    }).toList();

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
            Text(widget.title, style: AppTextStyles.h2.copyWith(fontSize: 18)),
            Text(
              '${filteredWorkers.length} verified professionals nearby',
              style: AppTextStyles.subtitleSmall,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // 1. SEARCH BAR & FILTER BUTTON
            // ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: AppTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText: 'Search by name or service...',
                          hintStyle: AppTextStyles.inputHint,
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textLight,
                            size: 20,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Filter Button (Opens Bottom Sheet #12)
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

            // ----------------------------------------------------
            // 2. HORIZONTAL FILTER CHIPS
            // ----------------------------------------------------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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

            // ----------------------------------------------------
            // 3. VERTICAL LIST OF FILTERED WORKER CARDS
            // ----------------------------------------------------
            Expanded(
              child: filteredWorkers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: AppColors.textLight,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No workers found matching your search',
                            style: AppTextStyles.subtitle,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10),
                      itemCount:
                          filteredWorkers.length, // ✅ Using filtered list
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final worker =
                            filteredWorkers[index]; // ✅ Using filtered list
                        return Workercard(
                          name: worker.name,
                          service: worker.service,
                          rating: worker.rating,
                          imageUrl: worker.imageUrl,
                          reviewCount: worker.reviewCount,
                          price: worker.price,
                          distance: worker.distance,
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
