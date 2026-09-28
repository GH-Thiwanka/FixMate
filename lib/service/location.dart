import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static final Geocoding _geocoding = Geocoding();

  /// 1. Requests GPS permission and returns the current user's address
  static Future<String> getCurrentAddress() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'GPS is disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permission denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Permission permanently denied';
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );

      return await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      // Fallback to last known position on failure/timeout
      try {
        Position? lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          return await getAddressFromCoordinates(
            lastPosition.latitude,
            lastPosition.longitude,
          );
        }
      } catch (_) {}
      return 'Could not retrieve location';
    }
  }

  /// 2. Converts any Lat/Lng coordinates into an address (used by Map Picker when dragging)
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String locality = place.locality?.isNotEmpty == true
            ? place.locality!
            : (place.subLocality ?? place.name ?? '');

        String country = place.country ?? '';

        if (locality.isNotEmpty && country.isNotEmpty) {
          return '$locality, $country';
        } else if (locality.isNotEmpty) {
          return locality;
        } else {
          return country;
        }
      }
      return 'Selected Location';
    } catch (e) {
      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }

  /// 3. Calculates distance between worker and customer (e.g. "1.8 km away")
  static String formatDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    double km = distanceInMeters / 1000;
    return '${km.toStringAsFixed(1)} km away';
  }
}
