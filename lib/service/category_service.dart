import 'package:fixmate/model/category_model.dart';
import 'package:fixmate/service/api_client.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final ApiClient _apiClient = ApiClient();
  List<CategoryModel>? _cachedCategories;

  Future<List<CategoryModel>> getCategories({bool forceRefresh = false}) async {
    if (_cachedCategories != null && !forceRefresh) {
      return _cachedCategories!;
    }

    try {
      final response = await _apiClient.get('/categories');
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> list = response.data;
        _cachedCategories = list
            .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return _cachedCategories!;
      }
      return _cachedCategories ?? [];
    } catch (e) {
      // Return cached if available, else throw
      if (_cachedCategories != null) return _cachedCategories!;
      rethrow;
    }
  }
}
