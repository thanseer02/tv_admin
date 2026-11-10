import '../model/url_item_model.dart';
import '../../../services/web_api_services.dart';
import '../../../utils/urls.dart';

extension DashboardRepoExtension on WebAPIService {
  Future<List<UrlItemModel>> getUrlsApi({
    String? search,
    String? category,
    String? status,
    String? environment,
  }) async {
    final queryParams = <String, dynamic>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (category != null && category.isNotEmpty && category != 'ALL') {
      queryParams['category'] = category;
    }
    if (status != null && status.isNotEmpty && status != 'ALL') {
      queryParams['status'] = status;
    }
    if (environment != null && environment.isNotEmpty && environment != 'ALL') {
      queryParams['environment'] = environment;
    }

    final response = await dio.get(
      urlGetUrls,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final List data = response.data as List;
    return data.map((json) => UrlItemModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<UrlItemModel> addUrlApi({
    required String name,
    required String address,
    required String description,
    required UrlEnvironment environment,
    required UrlStatus status,
  }) async {
    final payload = {
      'name': name,
      'title': name,
      'address': address,
      'url': address,
      'description': description,
      'notes': description,
      'environment': environment.name,
      'status': status.name,
    };

    final response = await dio.post(
      urlAddUrl,
      data: payload,
    );

    return UrlItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UrlItemModel> updateUrlApi(UrlItemModel item) async {
    final payload = {
      'name': item.name,
      'title': item.name,
      'address': item.address,
      'url': item.address,
      'description': item.description,
      'notes': item.description,
      'environment': item.environment.name,
      'status': item.status.name,
    };

    final response = await dio.put(
      urlUpdateUrl(item.id),
      data: payload,
    );

    return UrlItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteUrlApi(String id) async {
    await dio.delete(urlDeleteUrl(id));
  }

  Future<UrlItemModel> toggleStatusApi(String id) async {
    final response = await dio.patch(urlToggleStatusUrl(id));
    return UrlItemModel.fromJson(response.data as Map<String, dynamic>);
  }
}
