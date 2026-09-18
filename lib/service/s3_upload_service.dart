import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fixmate/service/api_client.dart';

class S3UploadService {
  static final Dio _rawDio = Dio(); // Separate Dio instance without default headers for S3 direct upload

  /// Uploads a profile image to Amazon S3 via AWS Pre-signed URL
  ///
  /// Flow:
  /// 1. Request S3 Pre-signed PUT URL from AWS API Gateway (`/media/presigned-url`)
  /// 2. Upload the raw image bytes directly to the S3 bucket using HTTP PUT
  /// 3. Returns the clean public S3 image URL for saving in the user profile
  static Future<String?> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    try {
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final fileBytes = await imageFile.readAsBytes();

      // 1. Request pre-signed URL from AWS Backend
      final response = await ApiClient().post(
        '/media/presigned-url',
        data: {
          'fileName': fileName,
          'fileType': 'image/jpeg',
          'folder': 'profiles/$userId',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic rawData = response.data;
        final Map<String, dynamic> data = rawData is String
            ? jsonDecode(rawData)
            : Map<String, dynamic>.from(rawData as Map);

        final String? uploadUrl = data['uploadUrl'];
        final String publicUrl = data['publicUrl'] ?? uploadUrl?.split('?').first ?? '';

        if (uploadUrl == null || uploadUrl.isEmpty) {
          return null;
        }

        // 2. Direct PUT upload to S3
        final uploadResponse = await _rawDio.put(
          uploadUrl,
          data: fileBytes,
          options: Options(
            headers: {
              'Content-Type': 'image/jpeg',
              'Content-Length': fileBytes.length,
            },
          ),
        );

        if (uploadResponse.statusCode == 200) {
          return publicUrl;
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('S3 Upload Error: $e');
      return null;
    }
  }
}
