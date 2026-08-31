import 'package:fixmate/service/location.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapLocationPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const MapLocationPickerScreen({super.key, this.initialPosition});

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(6.9271, 79.8612); // Colombo default
  String _selectedAddress = 'Detecting address...';
  bool _isGeocoding = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _center = widget.initialPosition!;
    }
    _fetchAddress(_center);
  }

  // Reverse geocode when dragging stops
  Future<void> _fetchAddress(LatLng pos) async {
    if (!mounted) return;
    setState(() => _isGeocoding = true);

    // Uses your device geocoding service
    final address = await LocationService.getAddressFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

    if (mounted) {
      setState(() {
        _selectedAddress = address;
        _isGeocoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location on Map', style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. High-Resolution Interactive Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all, // Enables pan, pinch zoom, drag
              ),
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture) {
                  _center = camera.center;
                }
              },
              onMapEvent: (event) {
                // When dragging stops, fetch the address of the center pin
                if (event is MapEventMoveEnd) {
                  _fetchAddress(_center);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.fixmate',
                maxZoom: 19,
              ),
            ],
          ),

          // 2. Fixed Center Pin (Movable Map under Pin)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 38.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_repair_service_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Selected Address Card & Confirm Action
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Service Address',
                    style: AppTextStyles.subtitleSmall,
                  ),
                  const SizedBox(height: 6),
                  _isGeocoding
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
                              'Locating address...',
                              style: AppTextStyles.subtitleSmall,
                            ),
                          ],
                        )
                      : Text(
                          _selectedAddress,
                          style: AppTextStyles.fieldLabel.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Return the selected address back to PostAJobScreen!
                        Navigator.pop(context, _selectedAddress);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm Location',
                        style: AppTextStyles.buttonPrimary,
                      ),
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
}
