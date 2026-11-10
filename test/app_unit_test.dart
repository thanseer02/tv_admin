import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linkdesk/features/dashboard/model/url_item_model.dart';
import 'package:linkdesk/models/user_model.dart';
import 'package:linkdesk/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('AuthService Tests', () {
    test('Initial auth state is unauthenticated', () {
      final auth = AuthService();
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
      expect(auth.authToken, isNull);
    });

    test('Setting session marks user as authenticated', () async {
      final auth = AuthService();
      const user = UserModel(
        id: 'usr_test',
        email: 'test@linkdesk.io',
        name: 'Test Admin',
        role: 'Administrator',
      );

      await auth.setSession(user: user, token: 'mock_jwt_token', remember: false);

      expect(auth.isAuthenticated, isTrue);
      expect(auth.currentUser?.email, 'test@linkdesk.io');
      expect(auth.authToken, 'mock_jwt_token');

      await auth.clearSession();
      expect(auth.isAuthenticated, isFalse);
    });
  });

  group('UrlItemModel Serialization Tests', () {
    test('Json parsing with aliases works correctly', () {
      final json = {
        'id': 'url_999',
        'title': 'Sample Feed',
        'url': 'https://stream.io/feed.m3u8',
        'notes': 'Notes description',
        'environment': 'production',
        'status': 'active',
        'refreshInterval': 30,
        'createdAt': '2026-11-10T08:00:00.000Z',
        'updatedAt': '2026-11-10T08:00:00.000Z',
      };

      final item = UrlItemModel.fromJson(json);

      expect(item.id, 'url_999');
      expect(item.name, 'Sample Feed');
      expect(item.address, 'https://stream.io/feed.m3u8');
      expect(item.description, 'Notes description');
      expect(item.status, UrlStatus.active);
      expect(item.environment, UrlEnvironment.production);
    });
  });
}
