import 'package:fixmate/data/subservice_data.dart';
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
  final SubserviceData _subServiceData = SubserviceData();

  // Step 1 State
  late String _selectedCategory;
  late String _selectedSubService;

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
    _selectedCategory = widget.initialCategory ?? 'Painting';
    final subList = _subServiceData.subServices[_selectedCategory] ?? [];
    _selectedSubService = subList.isNotEmpty
        ? subList.first
        : 'General Service';

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

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      PostJobSuccessDialog.show(context, onDone: () => context.pop());
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
        child: Column(
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
          selectedCategory: _selectedCategory,
          selectedSubService: _selectedSubService,
          subServices: _subServiceData.subServices,
          onCategorySelected: (cat) => setState(() {
            _selectedCategory = cat;
            final subList = _subServiceData.subServices[cat] ?? [];
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
              // If endHour is now equal to or before startHour, auto-advance it
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
