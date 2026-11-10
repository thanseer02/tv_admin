import 'package:flutter/material.dart';
import '../../../models/url_item_model.dart';
import '../../../providers/view_model.dart';
import '../../../services/web_api_services.dart';
import '../../../utils/extensions.dart';
import '../repo/dashboard_repo.dart';

class DashboardViewModel extends ViewModel {
  final PaginationController pagination = PaginationController();
  final TextEditingController searchController = TextEditingController();

  List<UrlItemModel> _urls = [];
  List<UrlItemModel> get urls => _urls;

  UrlEnvironment? _filterEnv;
  UrlEnvironment? get filterEnv => _filterEnv;

  UrlStatus? _filterStatus;
  UrlStatus? get filterStatus => _filterStatus;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int get totalUrls => _urls.length;
  int get activeUrls => _urls.where((u) => u.status == UrlStatus.active).length;
  int get inactiveUrls => totalUrls - activeUrls;

  List<UrlItemModel> get filteredUrls {
    return _urls.where((item) {
      final matchesQuery = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesEnv = _filterEnv == null || item.environment == _filterEnv;
      final matchesStatus = _filterStatus == null || item.status == _filterStatus;

      return matchesQuery && matchesEnv && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterEnv(UrlEnvironment? env) {
    _filterEnv = env;
    notifyListeners();
  }

  void setFilterStatus(UrlStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  Future<void> loadUrls() async {
    try {
      final items = await WebAPIService().getUrlsApi().setProgress(this);
      _urls = items;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading URLs: $e');
    }
  }

  Future<void> addUrl({
    required String name,
    required String address,
    required String description,
    required UrlEnvironment environment,
    required UrlStatus status,
  }) async {
    await WebAPIService()
        .addUrlApi(
          name: name,
          address: address,
          description: description,
          environment: environment,
          status: status,
        )
        .setProgress(this);
    await loadUrls();
  }

  Future<void> updateUrl(UrlItemModel item) async {
    await WebAPIService().updateUrlApi(item).setProgress(this);
    await loadUrls();
  }

  Future<void> deleteUrl(String id) async {
    await WebAPIService().deleteUrlApi(id).setProgress(this);
    await loadUrls();
  }

  Future<void> toggleStatus(String id) async {
    await WebAPIService().toggleStatusApi(id).setProgress(this);
    await loadUrls();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
