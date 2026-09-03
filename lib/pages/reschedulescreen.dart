import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/dateandhourspicker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RescheduleScreen extends StatefulWidget {
  final JobModel job;

  const RescheduleScreen({super.key, required this.job});

  static void show(BuildContext context, {required JobModel job}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => RescheduleScreen(job: job),
    );
  }

  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  late DateTime _selectedDate;
  int _startHour = 10;
  int _endHour = 14;
  String _selectedReason = 'Change of Plans';

  final List<String> _reasons = [
    'Change of Plans',
    'Emergency',
    'Worker Requested',
    'Weather Issue',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 2));
  }

  void _submitReschedule() {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reschedule request sent to ${widget.job.workerName ?? "Worker"}. You\'ll be notified when confirmed.',
        ),
        backgroundColor: const Color(0xFF168A55),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Reschedule Appointment', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),

            // 2. Current Appointment Details Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.event_busy_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Appointment',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.job.dateTime,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (widget.job.workerName != null)
                          Text(
                            'Worker: ${widget.job.workerName}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. REUSABLE DATE & TIME PICKER COMPONENT
            DateAndHoursPickerWidget(
              selectedDate: _selectedDate,
              startHour: _startHour,
              endHour: _endHour,
              dateTitle: 'Select New Date',
              timeTitle: 'New Working Hours',
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
            ),
            const SizedBox(height: 18),

            // 4. Reason for Reschedule Chips
            const Text('Reason for Rescheduling', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reasons.map((reason) {
                final isSelected = _selectedReason == reason;
                return ChoiceChip(
                  label: Text(reason),
                  selected: isSelected,
                  selectedColor: AppColors.primarySoft,
                  backgroundColor: AppColors.background,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedReason = reason);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 5. Free Reschedule Guarantee Callout
            Row(
              children: const [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF168A55),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Free rescheduling · No extra charges apply',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF168A55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 6. Confirm CTA Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitReschedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm Reschedule',
                  style: AppTextStyles.buttonPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
