import '../models/url_item.dart';

/// Contract for URL management repository
abstract class UrlRepository {
  Future<List<UrlItem>> getUrls();
  Future<UrlItem> addUrl({
    required String name,
    required String address,
    required String description,
    required UrlEnvironment environment,
    required UrlStatus status,
  });
  Future<UrlItem> updateUrl(UrlItem item);
  Future<void> deleteUrl(String id);
  Future<UrlItem> toggleStatus(String id);
}

/// In-memory & Local Mock implementation of UrlRepository
class MockUrlRepository implements UrlRepository {
  final List<UrlItem> _items = [
    UrlItem(
      id: 'url_101',
      name: 'Main Production Streaming Feed',
      address: 'https://stream.internal.net/live/prod-main.m3u8',
      description: 'Primary high-bitrate live video stream for lobby displays.',
      environment: UrlEnvironment.production,
      status: UrlStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    UrlItem(
      id: 'url_102',
      name: 'Executive Dashboard Display',
      address: 'https://bi-dashboard.company.internal/kpi-wallboard',
      description: 'Real-time telemetry, order fulfillment and server latency KPIs.',
      environment: UrlEnvironment.production,
      status: UrlStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UrlItem(
      id: 'url_103',
      name: 'Staging Channel 2 Preview',
      address: 'https://staging-media.company.com/stream/ch2.mpd',
      description: 'Candidate release testing stream for the upcoming TV app client update.',
      environment: UrlEnvironment.staging,
      status: UrlStatus.inactive,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    UrlItem(
      id: 'url_104',
      name: 'QA Automation Test Target',
      address: 'https://qa-testbed.company.org/stream-mock',
      description: 'Automated test suite endpoint verifying codec and DRM compliance.',
      environment: UrlEnvironment.testing,
      status: UrlStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    UrlItem(
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

  @override
  Future<List<UrlItem>> getUrls() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(_items);
  }

  @override
  Future<UrlItem> addUrl({
    required String name,
    required String address,
    required String description,
    required UrlEnvironment environment,
    required UrlStatus status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newItem = UrlItem(
      id: 'url_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      address: address,
      description: description,
      environment: environment,
      status: status,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items.insert(0, newItem);
    return newItem;
  }

  @override
  Future<UrlItem> updateUrl(UrlItem item) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index == -1) {
      throw Exception('URL item not found');
    }
    final updated = item.copyWith(updatedAt: DateTime.now());
    _items[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteUrl(String id) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _items.removeWhere((element) => element.id == id);
  }

  @override
  Future<UrlItem> toggleStatus(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((element) => element.id == id);
    if (index == -1) {
      throw Exception('URL item not found');
    }
    final current = _items[index];
    final updated = current.copyWith(
      status: current.status == UrlStatus.active ? UrlStatus.inactive : UrlStatus.active,
      updatedAt: DateTime.now(),
    );
    _items[index] = updated;
    return updated;
  }
}

