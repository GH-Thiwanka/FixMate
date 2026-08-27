import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static final Geocoding _geocoding = Geocoding();

  /// Requests permission and returns the formatted address (e.g. "Colombo 07, Sri Lanka")
  static Future<String?> getCurrentAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Test if location services (GPS) are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'GPS is disabled';
    }

    // 2. Check location permissions.
    permission = await Geolocator.checkPermission();
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
      // 3. Get device current GPS coordinates
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 4. Reverse geocode coordinates to get City / Locality
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Construct readable string: e.g. "Colombo 07, Sri Lanka" or "Kandy, Sri Lanka"
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
      return 'Current Location';
    } catch (e) {
      return 'Failed to get address';
    }
  }
}
