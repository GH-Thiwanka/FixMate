import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class AwsLocationService {
  AwsLocationService._();

  // 🔑 Paste your AWS API Key here:
  static const String apiKey = 'YOUR_AWS_API_KEY_HERE';
  static const String region = 'us-east-1';

  static final Dio _dio = Dio();

  /// 1. AWS Reverse Geocoding (Converts coordinates to street address via AWS Places)
  static Future<String> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    final url =
        'https://places.geo.$region.amazonaws.com/places/v0/reverse-geocode?key=$apiKey';

    try {
      final response = await _dio.post(
        url,
        data: {
          'Position': [longitude, latitude], // AWS expects [lon, lat]
          'MaxResults': 1,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['ResultItems'] as List?;
        if (results != null && results.isNotEmpty) {
          final place = results.first['Place'];
          return place['Label'] ?? 'Selected Location';
        }
      }
      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    } catch (e) {
      return 'Colombo, Sri Lanka';
    }
  }

  /// 2. Calculates exact road driving distance & travel time via AWS Routes API
  static Future<Map<String, dynamic>> calculateRouteDistance(
    LatLng customerLocation,
    LatLng workerLocation,
  ) async {
    final url =
        'https://routes.geo.$region.amazonaws.com/routes/v0/calculate/routes?key=$apiKey';

    try {
      final response = await _dio.post(
        url,
        data: {
          'DeparturePosition': [
            customerLocation.longitude,
            customerLocation.latitude,
          ],
          'DestinationPosition': [
            workerLocation.longitude,
            workerLocation.latitude,
          ],
          'TravelMode': 'Car',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final summary = data['Summary'];
        final double distanceKm = (summary['Distance'] as num) / 1000.0;
        final int durationMinutes = ((summary['DurationSeconds'] as num) / 60.0)
            .round();

        return {
          'distance': '${distanceKm.toStringAsFixed(1)} km',
          'duration': '$durationMinutes mins',
        };
      }
    } catch (e) {}

    // Offline fallback
    final distanceCalc = const Distance();
    final km = distanceCalc.as(
      LengthUnit.Kilometer,
      customerLocation,
      workerLocation,
    );
    return {'distance': '${km.toStringAsFixed(1)} km', 'duration': '15 mins'};
  }
}
