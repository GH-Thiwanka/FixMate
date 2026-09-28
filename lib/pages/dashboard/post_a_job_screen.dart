import 'dart:io';
import 'package:fixmate/model/category_model.dart';
import 'package:fixmate/service/category_service.dart';
import 'package:fixmate/service/job_service.dart';
import 'package:fixmate/service/s3_upload_service.dart';
import 'package:fixmate/service/location.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/auth_and_onboarding/submilbutton.dart';
import 'package:fixmate/widget/dateandhourspicker.dart';
import 'package:fixmate/widget/post_a_job/progress_bar.dart';
import 'package:fixmate/widget/post_a_job/step1.dart';
import 'package:fixmate/widget/post_a_job/step2.dart';
import 'package:fixmate/widget/post_a_job/step3.dart';
import 'package:fixmate/widget/post_a_job/step4.dart';
import 'package:fixmate/widget/post_a_job/step5.dart';
import 'package:fixmate/widget/post_a_job/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PostAJobScreen extends StatefulWidget {
  final String? initialCategory;

  const PostAJobScreen({super.key, this.initialCategory});

  @override
  State<PostAJobScreen> createState() => _PostAJobScreenState();
}

class _PostAJobScreenState extends State<PostAJobScreen> {
  int _currentStep = 0;
  final CategoryService _categoryService = CategoryService();
  List<CategoryModel> _categories = [];
  bool _isCategoriesLoaded = false;

  // Step 1 State
  String _selectedCategory = 'Painting';
  String _selectedSubService = 'General Service';

  // Step 2 State (Description, Property Type & Photo List)
  final TextEditingController _descriptionController = TextEditingController();
  String _propertyType = 'House';
  List<XFile> _selectedImages = [];

  // Step 3 State (Location, Date & Whole Hours)
  String _address = 'Detecting location...';
  bool _isLoadingLocation = true;
  bool _isLocationError = false;
  String _scheduleType = 'Schedule a Visit';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _startHour = 9; // 9:00 AM
  int _endHour = 15; // 3:00 PM

  // Step 4 State (Budget TextField Controller)
  String _budgetPreference = 'I Need Quotes';
  final TextEditingController _budgetController = TextEditingController(
    text: '15000',
  );

  // Step 5 State
  bool _broadcastToAll = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    setState(() {
      _isLoadingLocation = true;
      _isLocationError = false;
    });

    final String result = await LocationService.getCurrentAddress();
    final isError =
        result.contains('denied') ||
        result.contains('disabled') ||
        result.contains('Could not retrieve');

    if (mounted) {
      setState(() {
        _address = result;
        _isLoadingLocation = false;
        _isLocationError = isError;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  bool _isSubmitting = false;
  final JobService _jobService = JobService();

  void _nextStep() async {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      await _submitJob();
    }
  }

  Future<void> _submitJob() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    
    // Convert XFiles to standard Files if needed, but the service can be adapted or we use File(xfile.path).
    // The createJob expects a map of job data, and we can handle uploading inside JobService or here.
    try {
      final List<String> uploadedPhotoUrls = [];
      // Generate a temporary job ID for S3 folder structure
      final tempJobId = DateTime.now().millisecondsSinceEpoch.toString();

      for (var xFile in _selectedImages) {
        final publicUrl = await S3UploadService.uploadJobImage(
          imageFile: File(xFile.path),
          jobId: tempJobId,
        );
        if (publicUrl != null) uploadedPhotoUrls.add(publicUrl);
      }

      final jobData = {
        'id': tempJobId, // Usually the backend will assign a UUID, but we can pass this or let backend override.
        'category': _selectedCategory,
        'subService': _selectedSubService,
        'description': _descriptionController.text,
        'propertyType': _propertyType,
        'address': _address,
        'scheduledDate': _scheduleType == 'Schedule a Visit' 
            ? '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'
            : 'ASAP',
        'scheduledTime': _scheduleType == 'Schedule a Visit'
            ? '${_startHour}:00 - ${_endHour}:00'
            : 'Anytime',
        'budgetPreference': _budgetPreference,
        'budget': _budgetPreference == 'Fixed Budget' ? double.tryParse(_budgetController.text) : null,
        'broadcastToAll': _broadcastToAll,
        'photoUrls': uploadedPhotoUrls,
        'status': 'PENDING',
      };

      await _jobService.createJob(jobData);
      
      if (mounted) {
        PostJobSuccessDialog.show(context, onDone: () {
          context.go('/my-jobs');
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post job: \$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _previousStep,
        ),
        title: const Text('Post a Job', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<CategoryModel>>(
          future: _categoryService.getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !_isCategoriesLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading categories'));
            }
            if (snapshot.hasData && !_isCategoriesLoaded) {
              _categories = snapshot.data!;
              _isCategoriesLoaded = true;
              
              if (_categories.isNotEmpty) {
                // If the initial category wasn't found, default to the first one
                final catExists = _categories.any((c) => c.title == _selectedCategory);
                if (!catExists) _selectedCategory = _categories.first.title;

                final currentCat = _categories.firstWhere((c) => c.title == _selectedCategory, orElse: () => _categories.first);
                if (currentCat.subServices.isNotEmpty && _selectedSubService == 'General Service') {
                  _selectedSubService = currentCat.subServices.first;
                }
              }
            }

            return Column(
              children: [
                PostJobProgressBar(
                  currentStep: _currentStep,
                  stepTitle: _getStepTitle(),
                ),
                const Divider(color: AppColors.divider, height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildCurrentStepWidget(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Submilbutton(
                    buttonText: _currentStep == 4 ? 'Post Job Request' : 'Next',
                    handleSubmit: _nextStep,
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Select Service';
      case 1:
        return 'Project Details';
      case 2:
        return 'Location & Schedule';
      case 3:
        return 'Set Budget';
      case 4:
        return 'Review & Post';
      default:
        return '';
    }
  }

  Widget _buildCurrentStepWidget() {
    switch (_currentStep) {
      case 0:
        return Step1SelectServiceWidget(
          categories: _categories,
          selectedCategory: _selectedCategory,
          selectedSubService: _selectedSubService,
          onCategorySelected: (cat) => setState(() {
            _selectedCategory = cat;
            final subList = _categories.firstWhere((c) => c.title == cat, orElse: () => _categories.first).subServices;
            _selectedSubService = subList.isNotEmpty
                ? subList.first
                : 'General Service';
          }),
          onSubServiceSelected: (sub) =>
              setState(() => _selectedSubService = sub),
        );
      case 1:
        return Step2ProjectDetailsWidget(
          descriptionController: _descriptionController,
          selectedPropertyType: _propertyType,
          selectedImages: _selectedImages,
          onPropertyTypeChanged: (type) => setState(() => _propertyType = type),
          onImagesChanged: (images) => setState(() => _selectedImages = images),
        );
      case 2:
        return Step3LocationScheduleWidget(
          address: _address,
          isLoadingLocation: _isLoadingLocation,
          isLocationError: _isLocationError,
          onUseCurrentLocation: _loadUserAddress,
          onAddressChanged: (newAddress) =>
              setState(() => _address = newAddress),
          scheduleType: _scheduleType,
          selectedDate: _selectedDate,
          startHour: _startHour,
          endHour: _endHour,
          onScheduleTypeChanged: (type) => setState(() => _scheduleType = type),
          onDateChanged: (date) => setState(() => _selectedDate = date),
          onStartHourChanged: (hour) {
            setState(() {
              _startHour = hour;
              if (_endHour <= _startHour) {
                _endHour = (_startHour + 1).clamp(9, 18);
              }
            });
          },
          onEndHourChanged: (hour) => setState(() => _endHour = hour),
        );
      case 3:
        return Step4SetBudgetWidget(
          budgetPreference: _budgetPreference,
          budgetController: _budgetController,
          onBudgetPreferenceChanged: (pref) =>
              setState(() => _budgetPreference = pref),
        );
      case 4:
        return Step5ReviewPostWidget(
          category: _selectedCategory,
          subService: _selectedSubService,
          propertyType: _propertyType,
          location: _address.isNotEmpty ? _address : 'Colombo 07, Sri Lanka',
          schedule: _scheduleType == 'ASAP'
              ? 'ASAP (Emergency)'
              : '${DateAndHoursPickerWidget.formatDate(_selectedDate)} (${DateAndHoursPickerWidget.formatHour(_startHour)} - ${DateAndHoursPickerWidget.formatHour(_endHour)})',
          budget: _budgetPreference == 'Fixed Budget'
              ? 'Rs. ${_budgetController.text.isNotEmpty ? _budgetController.text : "15,000"}'
              : 'Competitive Quotes',
          broadcastToAll: _broadcastToAll,
          onBroadcastChanged: (val) => setState(() => _broadcastToAll = val),
        );
      default:
        return const SizedBox();
    }
  }
}
