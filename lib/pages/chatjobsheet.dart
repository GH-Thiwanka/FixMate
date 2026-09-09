import 'package:fixmate/model/chat_model.dart';
import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatJobSummarySheet extends StatelessWidget {
  final ConversationModel conversation;

  const ChatJobSummarySheet({super.key, required this.conversation});

  static void show(
    BuildContext context, {
    required ConversationModel conversation,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ChatJobSummarySheet(conversation: conversation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = conversation.activeJobTitle ?? 'Full Room Painting';
    final String jobId = conversation.activeJobId ?? '#JOB-84920';
    final String status = conversation.activeJobStatus ?? 'Worker on the Way';

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Grab Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Job Details', style: AppTextStyles.h2),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Job Title & Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.home_repair_service_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.h3),
                      const SizedBox(height: 2),
                      Text(
                        '$jobId • ${conversation.serviceCategory}',
                        style: AppTextStyles.subtitleSmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF47C20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Job Specifications Table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildInfoRow('Assigned Worker', conversation.workerName),
                const Divider(color: AppColors.divider, height: 16),
                _buildInfoRow('Appointment', 'Today, 2:30 PM - 5:30 PM'),
                const Divider(color: AppColors.divider, height: 16),
                _buildInfoRow(
                  'Service Address',
                  'No. 25, Galle Road, Colombo 03',
                ),
                const Divider(color: AppColors.divider, height: 16),
                _buildInfoRow('Agreed Price', 'Rs. 18,000', isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5. Start Verification PIN Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF168A55),
                  size: 22,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Share this 4-digit PIN with worker when they arrive:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF065F46),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Text(
                    '4920',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF168A55),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 6. Primary Action: Open Full Live Map Tracker
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Close sheet
                // Open full live tracker screen
                context.push(
                  '/active-job-tracking',
                  extra: JobModel(
                    id: jobId.replaceAll('#', ''),
                    title: title,
                    category: conversation.serviceCategory,
                    serviceIcon: 'assets/icons/paint.svg',
                    status: JobStatus.workerOnTheWay,
                    statusText: status,
                    dateTime: 'Today, 2:30 PM',
                    address: 'No. 25, Galle Road, Colombo 03',
                    price: 18000,
                    workerName: conversation.workerName,
                    workerAvatar: conversation.workerAvatar,
                    tab: JobTabType.active,
                  ),
                );
              },
              icon: const Icon(
                Icons.navigation_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Track Live on Map',
                style: AppTextStyles.buttonPrimary,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isBold ? 14.5 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
