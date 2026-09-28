import 'package:fixmate/model/job_model.dart';
import 'package:fixmate/service/api_client.dart';

class JobService {
  static final JobService _instance = JobService._internal();
  factory JobService() => _instance;
  JobService._internal();

  final ApiClient _apiClient = ApiClient();

  /// Create a new job in DynamoDB
  Future<JobModel?> createJob(Map<String, dynamic> jobData) async {
    try {
      final response = await _apiClient.post('/jobs', data: jobData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data != null && data['job'] != null) {
          return JobModel.fromJson(data['job'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print('Error creating job: ' + e.toString());
      rethrow;
    }
  }

  /// Fetch all jobs for the logged-in customer
  Future<List<JobModel>> getMyJobs() async {
    try {
      final response = await _apiClient.get('/jobs');
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> list = response.data;
        return list
            .map((item) => JobModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching my jobs: ' + e.toString());
      rethrow;
    }
  }

  /// Cancel a job
  Future<bool> cancelJob(String jobId) async {
    try {
      final response = await _apiClient.patch('/jobs/' + jobId + '/cancel');
      return response.statusCode == 200;
    } catch (e) {
      print('Error cancelling job: ' + e.toString());
      return false;
    }
  }
}
