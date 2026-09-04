import 'dart:io';

import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/auth_and_onboarding/submilbutton.dart';
import 'package:fixmate/widget/my_job/reviwe_success.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RateAndReviewScreen extends StatefulWidget {
  final JobModel? job;

  const RateAndReviewScreen({super.key, this.job});

  @override
  State<RateAndReviewScreen> createState() => _RateAndReviewScreenState();
}

class _RateAndReviewScreenState extends State<RateAndReviewScreen> {
  // Step 1: Star Rating
  int _rating = 5;

  // Step 2: Review Tags (Multi-select)
  final Set<String> _selectedTags = {'Punctual', 'Skilled', 'Clean Work'};
  final List<String> _allTags = [
    'Punctual',
    'Skilled',
    'Clean Work',
    'Good Communication',
    'Fair Pricing',
    'Professional',
    'Polite & Respectful',
    'Quick Service',
  ];

  // Step 3: Written Review
  final TextEditingController _reviewController = TextEditingController();

  // Step 4: Optional Photos (Max 3)
  final List<XFile> _reviewPhotos = [];

  // Tip Selection (Optional)
  int _tipAmount = 0;
  final List<int> _tipOptions = [0, 500, 1000, 2000];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String _getRatingFeedback(int rating) {
    switch (rating) {
      case 5:
        return 'Excellent! (5.0)';
      case 4:
        return 'Very Good (4.0)';
      case 3:
        return 'Average (3.0)';
      case 2:
        return 'Below Expectations (2.0)';
      case 1:
        return 'Poor (1.0)';
      default:
        return '';
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (_reviewPhotos.length >= 3) return;

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() => _reviewPhotos.add(photo));
    }
  }

  void _showPhotoDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Work Photo (Before/After)',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text(
                    'Take Photo',
                    style: AppTextStyles.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickPhoto(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: AppTextStyles.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickPhoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitReview() {
    ReviewSuccessDialog.show(
      context,
      onDone: () {
        context.pop(); // Returns to previous screen / My Jobs
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workerName = widget.job?.workerName ?? 'Nimal Jayasuriya';
    final jobTitle = widget.job?.title ?? 'Ceiling Fan & Switch Repair';
    final avatarUrl =
        widget.job?.workerAvatar ??
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Rate & Review', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------
              // WORKER & JOB SUMMARY CARD
              // ----------------------------------------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.primarySoft,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF168A55),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(workerName, style: AppTextStyles.h3),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F3FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Verified Pro',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0756A6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(jobTitle, style: AppTextStyles.subtitleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------
              // STEP 1: INTERACTIVE 1-5 STAR RATING
              // ----------------------------------------------------
              const Text('1. Rate Your Experience', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isFilled = starIndex <= _rating;

                        return GestureDetector(
                          onTap: () => setState(() => _rating = starIndex),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: Icon(
                              isFilled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 46,
                              color: isFilled
                                  ? const Color(0xFFFFB800)
                                  : AppColors.border,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRatingFeedback(_rating),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------
              // STEP 2: REVIEW TAGS (Multi-Select Chips)
              // ----------------------------------------------------
              const Text(
                '2. What went well? (Select tags)',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);

                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: AppColors.primarySoft,
                    backgroundColor: AppColors.surface,
                    checkmarkColor: AppColors.primary,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------
              // STEP 3: WRITTEN REVIEW (500 Char Max)
              // ----------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('3. Write a Review', style: AppTextStyles.h3),
                  Text(
                    '${_reviewController.text.length}/500',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _reviewController,
                  maxLength: 500,
                  maxLines: 4,
                  style: AppTextStyles.inputText,
                  onChanged: (text) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Share details about work quality, punctuality, and overall satisfaction to help others...',
                    hintStyle: AppTextStyles.inputHint,
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------
              // STEP 4: ADD PHOTOS (Before / After)
              // ----------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '4. Add Photos (Before / After)',
                    style: AppTextStyles.h3,
                  ),
                  Text(
                    '${_reviewPhotos.length}/3 photos',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (int i = 0; i < _reviewPhotos.length; i++)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                            image: DecorationImage(
                              image: FileImage(File(_reviewPhotos[i].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _reviewPhotos.removeAt(i)),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_reviewPhotos.length < 3)
                    InkWell(
                      onTap: _showPhotoDialog,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------
              // OPTIONAL TIP WORKER SECTION
              // ----------------------------------------------------
              const Text(
                'Add a Tip for Great Work? (Optional)',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 10),
              Row(
                children: _tipOptions.map((tip) {
                  final isSelected = _tipAmount == tip;
                  final label = tip == 0 ? 'No Tip' : 'Rs. $tip';

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        selectedColor: AppColors.primarySoft,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _tipAmount = tip);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // ----------------------------------------------------
              // SUBMIT REVIEW CTA BUTTON
              // ----------------------------------------------------
              Submilbutton(
                buttonText: 'Submit Review',
                handleSubmit: () {
                  _submitReview();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
