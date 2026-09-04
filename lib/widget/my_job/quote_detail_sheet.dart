import 'package:fixmate/model/quote_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class QuoteDetailSheet {
  static void show(
    BuildContext context, {
    required QuoteModel quote,
    required VoidCallback onAccept,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grab Handle
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

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quote Breakdown', style: AppTextStyles.h2),
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

                  // Worker Profile Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(quote.workerAvatar),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(quote.workerName, style: AppTextStyles.h3),
                              Text(
                                quote.workerTrade,
                                style: AppTextStyles.subtitleSmall,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFB800),
                                  size: 16,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${quote.workerRating}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              quote.distance,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Scope of Work
                  const Text('Scope of Work Included', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(
                    quote.scopeOfWork,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price Breakdown Table
                  const Text('Price Breakdown', style: AppTextStyles.h3),
                  const SizedBox(height: 10),
                  _buildCostRow(
                    'Labour Charges',
                    'Rs. ${quote.labourCost.toInt()}',
                  ),
                  _buildCostRow(
                    'Materials & Refills',
                    'Rs. ${quote.materialsCost.toInt()}',
                  ),
                  _buildCostRow(
                    'Visit & Inspection Charge',
                    'Rs. ${quote.visitCharge.toInt()}',
                  ),
                  _buildCostRow(
                    'FixMate Platform Fee',
                    'Free',
                    isHighlighted: true,
                  ),
                  const Divider(color: AppColors.divider, height: 20),
                  _buildCostRow(
                    'Total Amount',
                    'Rs. ${quote.totalAmount.toInt()}',
                    isTotal: true,
                  ),
                  const SizedBox(height: 20),

                  // Warranty & Protection Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
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
                        Expanded(
                          child: Text(
                            'Backed by FixMate ${quote.warrantyDays}-Day Service Warranty & 100% Satisfaction Guarantee.',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF065F46),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Accept Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onAccept();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Accept & Proceed to Book',
                        style: AppTextStyles.buttonPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildCostRow(
    String title,
    String cost, {
    bool isHighlighted = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13.5,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: isHighlighted
                  ? const Color(0xFF168A55)
                  : (isTotal ? AppColors.textPrimary : AppColors.textSecondary),
            ),
          ),
          Text(
            cost,
            style: TextStyle(
              fontSize: isTotal ? 17 : 13.5,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isHighlighted
                  ? const Color(0xFF168A55)
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
