import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class WorkerBottomActionBar extends StatelessWidget {
  final VoidCallback onChatPressed;
  final VoidCallback onRequestQuotePressed;

  const WorkerBottomActionBar({
    super.key,
    required this.onChatPressed,
    required this.onRequestQuotePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // "Chat" Button (Screen #28: Worker Chat)
          OutlinedButton.icon(
            onPressed: onChatPressed,
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF0756A6),
              size: 18,
            ),
            label: const Text(
              'Chat',
              style: TextStyle(
                color: Color(0xFF0756A6),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF0756A6), width: 1.4),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // "Request Quote" CTA (Screen #15: Create Job Stepper)
          Expanded(
            child: ElevatedButton(
              onPressed: onRequestQuotePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Request Quote',
                style: AppTextStyles.buttonPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
