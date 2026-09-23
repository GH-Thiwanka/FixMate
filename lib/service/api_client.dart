import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  // Base URL for AWS API Gateway / Backend Services
  static const String baseUrl = 'https://mvdlldudvf.execute-api.us-east-1.amazonaws.com/prod';

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Auth Token Interceptor (Section 1 & 5 of Architecture Doc)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            try {
              // Retrieve fresh Firebase ID token
              final String? token = await user.getIdToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            } catch (e) {
              // Token retrieval failed, proceed without token or handle error
            }
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Centralized error handling (e.g., 401 Unauthorized token expiry)
          if (error.response?.statusCode == 401) {
            // Can trigger sign-out or token refresh if necessary
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Convenience methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.put(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.delete(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.patch(path, data: data, queryParameters: queryParameters, options: options);
  }
}
