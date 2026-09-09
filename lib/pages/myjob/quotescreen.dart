import 'package:fixmate/data/quote_data.dart';
import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/model/quote_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/my_job/quote_card.dart';
import 'package:fixmate/widget/my_job/quote_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuotesReceivedScreen extends StatefulWidget {
  final JobModel? job;

  const QuotesReceivedScreen({super.key, this.job});

  @override
  State<QuotesReceivedScreen> createState() => _QuotesReceivedScreenState();
}

class _QuotesReceivedScreenState extends State<QuotesReceivedScreen> {
  late List<QuoteModel> _quoteList;

  @override
  void initState() {
    super.initState();
    _quoteList = List.from(QuotesData.quotes);
  }

  void _acceptQuote(QuoteModel quote) {
    // Navigate to Booking & Payment (Screen #23)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Accepted quote from ${quote.workerName}! Proceeding to booking...',
        ),
        backgroundColor: const Color(0xFF168A55),
      ),
    );
    // context.push('/booking-summary', extra: quote);
  }

  void _openChat(QuoteModel quote) {
    // context.push('/chat', extra: quote.workerName);
  }

  @override
  Widget build(BuildContext context) {
    final String jobTitle = widget.job?.title ?? 'AC Gas Refill & Cleaning';
    final String jobId = widget.job?.id ?? '#JOB-84919';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Quotes Received (${_quoteList.length})',
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _quoteList.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Collapsible Job Summary Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
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
                            Icons.build_circle_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jobTitle,
                                style: AppTextStyles.h3.copyWith(fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$jobId • Under Review by Workers',
                                style: AppTextStyles.subtitleSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Verified Quotes List
                  for (final quote in _quoteList)
                    QuoteCard(
                      quote: quote,
                      onAccept: () => _acceptQuote(quote),
                      onChat: () => _openChat(quote),
                      onTap: () => QuoteDetailSheet.show(
                        context,
                        quote: quote,
                        onAccept: () => _acceptQuote(quote),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // 3. FixMate Protection Guarantee Notice
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.shield_outlined,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'All quotes include worker verification, secure milestone escrow, and 100% satisfaction guarantee.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 56,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text('No Quotes Yet', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            const Text(
              'Nearby verified workers are reviewing your request. You will receive notifications as soon as quotes arrive.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitleSmall,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to My Jobs'),
            ),
          ],
        ),
      ),
    );
  }
}
