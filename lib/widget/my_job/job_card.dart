import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/auth_and_onboarding/submilbutton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({super.key, required this.job});

  Color _getStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.quoteReceived:
      case JobStatus.confirmed:
        return const Color(0xFF0756A6); // Blue #0756A6
      case JobStatus.workerOnTheWay:
      case JobStatus.inProgress:
      case JobStatus.awaitingPayment:
        return const Color(0xFFF47C20); // Orange #F47C20
      case JobStatus.completed:
        return const Color(0xFF168A55); // Green #168A55
      case JobStatus.cancelled:
        return const Color(0xFFC93636); // Red #C93636
    }
  }

  Color _getStatusBgColor(JobStatus status) {
    return _getStatusColor(status).withOpacity(0.12);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(job.status);
    final statusBgColor = _getStatusBgColor(job.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Title, Status Badge & Worker Avatar
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: AppTextStyles.h3.copyWith(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              job.statusText,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (job.photoUrls.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          job.photoUrls[0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        ),
                      )
                    else
                      _buildPlaceholder(),
                  ],
                ),
              ),
              // Worker Info (if assigned)
              if (job.workerName != null) ...[
                const SizedBox(width: 10),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primarySoft,
                      backgroundImage: job.workerAvatar != null
                          ? NetworkImage(job.workerAvatar!)
                          : null,
                      child: job.workerAvatar == null
                          ? const Icon(Icons.person, color: AppColors.primary)
                          : null,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      job.workerName!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.divider, height: 1),
          ),

          // 2. Job Metadata: Date, Location, Price
          ListTile(
            minTileHeight: 0,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            leading: const Icon(
              Icons.access_time_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),

            title: Text(job.dateTime, style: AppTextStyles.subtitleSmall),
          ),
          ListTile(
            minTileHeight: 0,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            leading: const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),

            title: Text(
              job.address,
              style: AppTextStyles.subtitleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (job.price != null) ...[
            ListTile(
              minTileHeight: 0,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              title: Text(
                'Rs. ${job.price!.toInt()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],

          // 3. Dynamic Action Buttons based on Status & Flow
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (job.tab) {
      // --- ACTIVE TAB ACTIONS ---
      case JobTabType.active:
        if (job.status == JobStatus.quoteReceived) {
          return Submilbutton(
            buttonTextsize: 14,
            height: 42,
            buttonText: 'View Quotes (${job.quoteCount})',
            handleSubmit: () {
              context.push('/quotes', extra: job);
            },
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: Submilbutton(
                  buttonTextsize: 14,
                  height: 42,
                  buttonText: 'Track Live',
                  handleSubmit: () {
                    context.push('/active-job-tracking', extra: job);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/chat', extra: job.workerName);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

      // --- UPCOMING TAB ACTIONS ---
      case JobTabType.upcoming:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.push('/chat', extra: job.workerName);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Message',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.push('/reschedule', extra: job);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Reschedule',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        );

      // --- COMPLETED TAB ACTIONS ---
      case JobTabType.completed:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.push('/rate-review', extra: job);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Rate & Review',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Invoice (PDF)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        );

      // --- CANCELLED TAB ACTIONS ---
      case JobTabType.cancelled:
        return SizedBox(
          width: double.infinity,
          height: 38,
          child: OutlinedButton(
            onPressed: () {
              context.push('/refund-support', extra: job);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Refund & Support',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 24),
    );
  }
}
