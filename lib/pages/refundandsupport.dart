import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RefundAndSupportScreen extends StatefulWidget {
  final JobModel? job;

  const RefundAndSupportScreen({super.key, this.job});

  @override
  State<RefundAndSupportScreen> createState() => _RefundAndSupportScreenState();
}

class _RefundAndSupportScreenState extends State<RefundAndSupportScreen> {
  // FAQs Expansion State
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How long does a refund take to process?',
      'answer': 'Refunds are initiated instantly upon cancellation. Depending on your bank/card issuer, funds typically reflect in your account within 2 to 3 business days.',
      'isExpanded': false,
    },
    {
      'question': 'Where will my refund be sent?',
      'answer': 'All refunds are automatically credited back to the original payment method used during booking (Credit/Debit card or FixMate Wallet).',
      'isExpanded': false,
    },
    {
      'question': 'Why was my job cancelled?',
      'answer': 'Jobs can be cancelled by you or the service provider due to scheduling conflicts, weather conditions, or emergencies. 100% of your funds are protected.',
      'isExpanded': false,
    },
    {
      'question': 'How do I raise a dispute or complaint?',
      'answer': 'If you experienced an issue with a worker or uncompleted work, tap "Live Chat Support" below to open an immediate investigation with our resolution team.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String title = widget.job?.title ?? 'Door Lock Replacement';
    final String jobId = widget.job?.id ?? 'JOB-84722';
    final double amount = widget.job?.price ?? 3200;
    final String address = widget.job?.address ?? 'Rajagiriya, Colombo';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Refund & Support', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // 1. CANCELLED JOB HEADER CARD
              // ==============================================================
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFFC93636),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTextStyles.h3),
                          const SizedBox(height: 2),
                          Text(
                            '#$jobId • $address',
                            style: AppTextStyles.subtitleSmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        'Rs. ${amount.toInt()}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF168A55),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==============================================================
              // 2. 4-STEP REFUND TIMELINE TRACKER
              // ==============================================================
              const Text('Refund Status', style: AppTextStyles.h3),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildTimelineStep(
                      title: 'Refund Requested',
                      time: 'Aug 20, 11:30 AM',
                      subtitle: 'Initiated immediately upon cancellation',
                      isCompleted: true,
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      title: 'Refund Approved',
                      time: 'Aug 20, 12:15 PM',
                      subtitle: 'Approved by FixMate Resolution Team',
                      isCompleted: true,
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      title: 'Bank Processing',
                      time: 'Aug 20, 02:45 PM',
                      subtitle: 'Processing by your bank (2-3 business days)',
                      isCurrent: true,
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      title: 'Credited to Account',
                      time: 'Pending',
                      subtitle: 'Estimated arrival: Aug 23 - Aug 24',
                      isCompleted: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==============================================================
              // 3. PAYMENT & REFUND BREAKDOWN
              // ==============================================================
              const Text('Payment Details', style: AppTextStyles.h3),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Total Paid', 'Rs. ${amount.toInt()}'),
                    _buildDetailRow(
                      'Cancellation Fee',
                      'Rs. 0 (Free within policy)',
                      isGreen: true,
                    ),
                    const Divider(color: AppColors.divider, height: 20),
                    _buildDetailRow(
                      'Refundable Amount',
                      'Rs. ${amount.toInt()}',
                      isBold: true,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.credit_card_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Refund Destination: Visa ending in •••• 4242',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==============================================================
              // 4. QUICK SUPPORT ACTIONS (Chat & Call)
              // ==============================================================
              const Text('Need Help?', style: AppTextStyles.h3),
              const SizedBox(height: 12),

              Row(
                children: [
                  // Live Chat Support Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // context.push('/support-chat');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Connecting to 24/7 FixMate Support Chat...',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0756A6), // Blue
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.support_agent_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Live Chat',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Instant help 24/7',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Call Support Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Calling Support Helpline: +94 11 234 5678',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF168A55), // Green
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.phone_in_talk_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Call Helpline',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Speak to an agent',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ==============================================================
              // 5. FREQUENTLY ASKED QUESTIONS (Accordion)
              // ==============================================================
              const Text('Frequently Asked Questions', style: AppTextStyles.h3),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: List.generate(_faqs.length, (index) {
                    final faq = _faqs[index];
                    final isExpanded = faq['isExpanded'] as bool;
                    final isLast = index == _faqs.length - 1;

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            faq['question'] as String,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            setState(() {
                              _faqs[index]['isExpanded'] = !isExpanded;
                            });
                          },
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 14,
                            ),
                            child: Text(
                              faq['answer'] as String,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        if (!isLast)
                          const Divider(color: AppColors.divider, height: 1),
                      ],
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Step Builder for Refund Timeline ---
  Widget _buildTimelineStep({
    required String title,
    required String time,
    required String subtitle,
    bool isCompleted = false,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    Color dotColor = isCompleted
        ? const Color(0xFF168A55)
        : (isCurrent ? AppColors.primary : AppColors.border);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: AppColors.primarySoft, width: 4)
                      : null,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : (isCurrent
                          ? const Center(
                              child: SizedBox(
                                width: 8,
                                height: 8,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCompleted
                        ? const Color(0xFF168A55)
                        : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Step Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCurrent || isCompleted
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCurrent || isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isGreen = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isGreen ? const Color(0xFF168A55) : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
