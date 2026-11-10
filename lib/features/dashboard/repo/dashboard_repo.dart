import '../../../models/url_item_model.dart';
import '../../../services/web_api_services.dart';

extension DashboardRepoExtension on WebAPIService {
  static final List<UrlItemModel> _memoryStore = [
    UrlItemModel(
      id: 'url_101',
      name: 'Main Production Streaming Feed',
      address: 'https://stream.internal.net/live/prod-main.m3u8',
      description: 'Primary high-bitrate live video stream for lobby displays.',
      environment: UrlEnvironment.production,
      status: UrlStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    UrlItemModel(
      id: 'url_102',
      name: 'Executive Dashboard Display',
      address: 'https://bi-dashboard.company.internal/kpi-wallboard',
      description: 'Real-time telemetry, order fulfillment and server latency KPIs.',
      environment: UrlEnvironment.production,
      status: UrlStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UrlItemModel(
      id: 'url_103',
      name: 'Staging Channel 2 Preview',
      address: 'https://staging-media.company.com/stream/ch2.mpd',
      description: 'Candidate release testing stream for the upcoming TV app client update.',
      environment: UrlEnvironment.staging,
      status: UrlStatus.inactive,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    UrlItemModel(
      id: 'url_104',
      name: 'QA Automation Test Target',
      address: 'https://qa-testbed.company.org/stream-mock',
      description: 'Automated test suite endpoint verifying codec and DRM compliance.',
      environment: UrlEnvironment.testing,
      status: UrlStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    UrlItemModel(
      id: 'url_105',
      name: 'Emergency Broadcast Override',
      address: 'https://safety.corp.internal/alert-feed',
      description: 'Triggered when facility emergency messaging requires global takeover.',
      environment: UrlEnvironment.other,
      status: UrlStatus.inactive,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  Future<List<UrlItemModel>> getUrlsApi() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_memoryStore);
  }

  Future<UrlItemModel> addUrlApi({
    required String name,
    required String address,
    required String description,
    required UrlEnvironment environment,
    required UrlStatus status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final newItem = UrlItemModel(
      id: 'url_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      address: address,
      description: description,
      environment: environment,
      status: status,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _memoryStore.insert(0, newItem);
    return newItem;
  }

  Future<UrlItemModel> updateUrlApi(UrlItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final index = _memoryStore.indexWhere((element) => element.id == item.id);
    if (index == -1) throw Exception('URL item not found');
    final updated = item.copyWith(updatedAt: DateTime.now());
    _memoryStore[index] = updated;
    return updated;
  }

  Future<void> deleteUrlApi(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _memoryStore.removeWhere((element) => element.id == id);
  }

  Future<UrlItemModel> toggleStatusApi(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _memoryStore.indexWhere((element) => element.id == id);
    if (index == -1) throw Exception('URL item not found');
    final current = _memoryStore[index];
    final updated = current.copyWith(
      status: current.status == UrlStatus.active ? UrlStatus.inactive : UrlStatus.active,
      updatedAt: DateTime.now(),
    );
    _memoryStore[index] = updated;
    return updated;
  }
}

