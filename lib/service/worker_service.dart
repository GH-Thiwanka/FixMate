import 'package:fixmate/model/worker_model.dart';
import 'package:fixmate/service/api_client.dart';

class WorkerService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches a list of verified workers, optionally filtered by category
  Future<List<WorkerModel>> getWorkers({String? category}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final response = await _apiClient.get('/workers', queryParameters: queryParams);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> list = response.data;
        return list.map((item) => WorkerModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching workers: $e');
      throw Exception('Failed to load workers');
    }
  }

  /// Fetches a single worker by their unique ID
  Future<WorkerModel?> getWorkerById(String workerId) async {
    try {
      final response = await _apiClient.get('/workers/$workerId');
      
      if (response.statusCode == 200 && response.data != null) {
        return WorkerModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching worker details: $e');
      return null;
    }
  }
}
