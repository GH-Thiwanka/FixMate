import 'package:fixmate/pages/dashboard/map_location.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class Step3LocationScheduleWidget extends StatelessWidget {
  final String address;
  final bool isLoadingLocation;
  final bool isLocationError;
  final VoidCallback onUseCurrentLocation;
  final ValueChanged<String> onAddressChanged;
  final String scheduleType;
  final DateTime selectedDate;
  final int startHour; // 8 to 17
  final int endHour; // (startHour + 1) to 18
  final ValueChanged<String> onScheduleTypeChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onStartHourChanged;
  final ValueChanged<int> onEndHourChanged;

  const Step3LocationScheduleWidget({
    super.key,
    required this.address,
    required this.isLoadingLocation,
    required this.isLocationError,
    required this.onUseCurrentLocation,
    required this.onAddressChanged,
    required this.scheduleType,
    required this.selectedDate,
    required this.startHour,
    required this.endHour,
    required this.onScheduleTypeChanged,
    required this.onDateChanged,
    required this.onStartHourChanged,
    required this.onEndHourChanged,
  });

  // Helper method to format whole hour into readable 12h AM/PM string
  static String formatHour(int hour) {
    if (hour == 12) return '12:00 PM';
    if (hour > 12) return '${hour - 12}:00 PM';
    return '$hour:00 AM';
  }

  // Format date helper (e.g. "Wed, Sep 3, 2026")
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final isTomorrow =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1;

    String prefix = isToday ? 'Today, ' : (isTomorrow ? 'Tomorrow, ' : '');
    return '$prefix${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Calendar Date Picker
  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  // Hours Selection Bottom Sheet (Dynamic Filtering)
  void _pickHourBottomSheet(BuildContext context, bool isStart) {
    // "From Hour": 8 AM (8) to 5 PM (17)
    // "To Hour": Only hours strictly AFTER startHour up to 6 PM (18)
    final int minHour = isStart ? 8 : (startHour + 1);
    final int maxHour = isStart ? 17 : 18;
    final int count = (maxHour - minHour + 1).clamp(1, 11);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isStart
                          ? 'Select Start Hour (From)'
                          : 'Select End Hour (To)',
                      style: AppTextStyles.h3,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(count, (index) {
                    final hour = minHour + index;
                    final isSelected = isStart
                        ? (hour == startHour)
                        : (hour == endHour);

                    return InkWell(
                      onTap: () {
                        if (isStart) {
                          onStartHourChanged(hour);
                        } else {
                          onEndHourChanged(hour);
                        }
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          formatHour(hour),
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ----------------------------------------------------
        // 1. SERVICE LOCATION HEADER & ACTIONS
        // ----------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Service Location', style: AppTextStyles.h3),
            Row(
              children: [
                // "GPS" Quick Button
                InkWell(
                  onTap: onUseCurrentLocation,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.my_location_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'GPS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // "Pick on Map" Button
                InkWell(
                  onTap: () async {
                    final selectedAddress = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapLocationPickerScreen(),
                      ),
                    );

                    if (selectedAddress != null && selectedAddress.isNotEmpty) {
                      onAddressChanged(selectedAddress);
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.map_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Pick on Map',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ----------------------------------------------------
        // 2. READ-ONLY LOCATION DISPLAY CARD
        // ----------------------------------------------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isLocationError
                ? const Color(0xFFFEF2F2)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isLocationError
                  ? const Color(0xFFFECACA)
                  : AppColors.border,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isLocationError
                    ? Icons.location_off_rounded
                    : Icons.location_on_rounded,
                color: isLocationError ? AppColors.error : AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: isLoadingLocation
                    ? const Row(
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Detecting GPS location...',
                            style: AppTextStyles.subtitleSmall,
                          ),
                        ],
                      )
                    : Text(
                        address,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isLocationError
                              ? AppColors.error
                              : AppColors.textPrimary,
                          fontWeight: isLocationError
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        ),

        if (isLocationError)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Row(
              children: const [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: AppColors.error,
                ),
                SizedBox(width: 4),
                Text(
                  'GPS failed. Tap "GPS" to retry or "Pick on Map".',
                  style: TextStyle(fontSize: 11.5, color: AppColors.error),
                ),
              ],
            ),
          ),

        const SizedBox(height: 24),

        // ----------------------------------------------------
        // 3. SCHEDULE SELECTION (ASAP vs Schedule Visit)
        // ----------------------------------------------------
        const Text('When do you need this?', style: AppTextStyles.h3),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildChoiceCard(
                'ASAP (Emergency)',
                Icons.bolt_rounded,
                scheduleType == 'ASAP',
                () => onScheduleTypeChanged('ASAP'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceCard(
                'Schedule Visit',
                Icons.calendar_today_rounded,
                scheduleType == 'Schedule a Visit',
                () => onScheduleTypeChanged('Schedule a Visit'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ----------------------------------------------------
        // 4. DATE & DYNAMICALLY FILTERED HOURS
        // ----------------------------------------------------
        if (scheduleType == 'Schedule a Visit') ...[
          // --- A. CALENDAR DATE PICKER ---
          const Text('Preferred Service Date', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _pickDate(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                      Icons.calendar_month_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(selectedDate),
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('Change', style: AppTextStyles.link),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- B. FROM & TO HOURS (Dynamic Filtering) ---
          const Text(
            'Preferred Working Hours Window',
            style: AppTextStyles.fieldLabel,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // From Hour Picker
              Expanded(
                child: _buildHourPickerCard(
                  context,
                  label: 'From Hour',
                  hourText: formatHour(startHour),
                  onTap: () => _pickHourBottomSheet(context, true),
                ),
              ),
              const SizedBox(width: 12),
              // To Hour Picker (Filtered)
              Expanded(
                child: _buildHourPickerCard(
                  context,
                  label: 'To Hour',
                  hourText: formatHour(endHour),
                  onTap: () => _pickHourBottomSheet(context, false),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildHourPickerCard(
    BuildContext context, {
    required String label,
    required String hourText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                Icons.schedule_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hourText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
