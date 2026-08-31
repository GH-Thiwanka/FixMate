import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class PostJobSuccessDialog extends StatelessWidget {
  final VoidCallback onDone;

  const PostJobSuccessDialog({super.key, required this.onDone});

  static void show(BuildContext context, {required VoidCallback onDone}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PostJobSuccessDialog(onDone: onDone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 44,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Job Posted Successfully!',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Nearby verified workers have been notified. You will receive quotes shortly in My Jobs.',
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDone();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Home',
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
