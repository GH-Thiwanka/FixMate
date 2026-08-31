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
  final String selectedTimeSlot;
  final ValueChanged<String> onScheduleTypeChanged;
  final ValueChanged<String> onTimeSlotChanged;

  const Step3LocationScheduleWidget({
    super.key,
    required this.address,
    required this.isLoadingLocation,
    required this.isLocationError,
    required this.onUseCurrentLocation,
    required this.onAddressChanged,
    required this.scheduleType,
    required this.selectedTimeSlot,
    required this.onScheduleTypeChanged,
    required this.onTimeSlotChanged,
  });

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
        // 2. READ-ONLY LOCATION DISPLAY CARD (No Typing)
        // ----------------------------------------------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isLocationError
                ? const Color(0xFFFEF2F2)
                : AppColors.background,
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
        const SizedBox(height: 20),

        // ----------------------------------------------------
        // 4. TIME SLOT SELECTION (If Schedule a Visit)
        // ----------------------------------------------------
        if (scheduleType == 'Schedule a Visit') ...[
          const Text('Preferred Time Slot', style: AppTextStyles.fieldLabel),
          const SizedBox(height: 8),
          Column(
            children:
                [
                  'Morning (9 AM - 12 PM)',
                  'Afternoon (12 PM - 4 PM)',
                  'Evening (4 PM - 7 PM)',
                ].map((slot) {
                  return RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(slot, style: AppTextStyles.bodyMedium),
                    value: slot,
                    groupValue: selectedTimeSlot,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      if (val != null) onTimeSlotChanged(val);
                    },
                  );
                }).toList(),
          ),
        ],
      ],
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
          color: isSelected ? AppColors.primarySoft : AppColors.background,
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
