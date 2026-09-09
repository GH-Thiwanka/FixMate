import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/pages/callscreen.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class ActiveJobTrackingScreen extends StatefulWidget {
  final JobModel? job;

  const ActiveJobTrackingScreen({super.key, this.job});

  @override
  State<ActiveJobTrackingScreen> createState() =>
      _ActiveJobTrackingScreenState();
}

class _ActiveJobTrackingScreenState extends State<ActiveJobTrackingScreen> {
  // Current status index: 0=Booking Confirmed, 1=Worker on the Way, 2=Worker Arrived, 3=Job in Progress, 4=Completed
  int _currentProgressStep = 1;

  final LatLng _workerLocation = const LatLng(6.9147, 79.8660); // Colombo
  final LatLng _userLocation = const LatLng(6.9015, 79.8550);

  final List<String> _progressStages = [
    'Booking Confirmed',
    'Worker on the Way',
    'Worker Arrived',
    'Job in Progress',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    final String title = widget.job?.title ?? 'Full Room Painting';
    final String jobId = widget.job?.id ?? 'JOB-84920';
    final String workerName = widget.job?.workerName ?? 'Sunil Perera';
    final String workerAvatar =
        widget.job?.workerAvatar ??
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150';
    final String address =
        widget.job?.address ?? 'No. 25, Galle Road, Colombo 03';
    final double price = widget.job?.price ?? 18000;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(title, style: AppTextStyles.h2.copyWith(fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: () =>
                context.push('/refund-and-support', extra: widget.job),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // 1. LIVE ROUTE MAP
              // ==============================================================
              Container(
                height: 220,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: _workerLocation,
                        initialZoom: 13.5,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.fixmate.app',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [_workerLocation, _userLocation],
                              strokeWidth: 4.0,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            // Worker Marker
                            Marker(
                              point: _workerLocation,
                              width: 48,
                              height: 48,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(workerAvatar),
                                ),
                              ),
                            ),
                            // User Home Marker
                            Marker(
                              point: _userLocation,
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0756A6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.home_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // ETA Floating Overlay Pill
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.directions_car_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'ETA: ~12 Mins',
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
              ),

              const SizedBox(height: 12),

              // ==============================================================
              // 2. WORKER CARD & CALL / CHAT ACTIONS
              // ==============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(workerAvatar),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(workerName, style: AppTextStyles.h3),
                                const SizedBox(height: 2),
                                const Text(
                                  'Verified FixMate Professional',
                                  style: AppTextStyles.subtitleSmall,
                                ),
                              ],
                            ),
                          ),
                          // 4-Digit Security PIN to share with worker upon arrival
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: const [
                                Text(
                                  'START PIN',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '4920',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          // Call Button -> Navigates to CallScreen
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CallScreen(
                                      workerName: workerName,
                                      workerTrade: 'Master Painter',
                                      workerAvatar: workerAvatar,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.phone_in_talk_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Call Worker',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF168A55,
                                ), // Green
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Message Button -> Navigates to Chat
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.push('/messages'),
                              icon: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              label: const Text(
                                'Message',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==============================================================
              // 3. PROGRESS TIMELINE (Linear progression)
              // ==============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  'Live Progress Tracker',
                  style: AppTextStyles.h3,
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: List.generate(_progressStages.length, (index) {
                      final isCompleted = index < _currentProgressStep;
                      final isCurrent = index == _currentProgressStep;
                      final isLast = index == _progressStages.length - 1;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? const Color(0xFF168A55)
                                        : (isCurrent
                                              ? AppColors.primary
                                              : AppColors.border),
                                    shape: BoxShape.circle,
                                  ),
                                  child: isCompleted
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : (isCurrent
                                            ? const Center(
                                                child: SizedBox(
                                                  width: 8,
                                                  height: 8,
                                                  child:
                                                      CircularProgressIndicator(
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
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      color: isCompleted
                                          ? const Color(0xFF168A55)
                                          : AppColors.border,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: isLast ? 0 : 20,
                                ),
                                child: Text(
                                  _progressStages[index],
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isCurrent || isCompleted
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isCurrent || isCompleted
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==============================================================
              // 4. JOB DETAILS SUMMARY CARD
              // ==============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text('Job Overview', style: AppTextStyles.h3),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Job Reference', '#$jobId'),
                      const Divider(color: AppColors.divider, height: 16),
                      _buildInfoRow('Service Location', address),
                      const Divider(color: AppColors.divider, height: 16),
                      _buildInfoRow(
                        'Total Agreed Amount',
                        'Rs. ${price.toInt()}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
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
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
