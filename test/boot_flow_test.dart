import 'package:atm_app/config/router/app_router_notifier.dart';
import 'package:atm_app/main.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/providers/auth/auth_snapshot_provider.dart';
import 'package:atm_app/presentation/providers/storage/theme_storage_provider.dart';
import 'package:atm_app/presentation/providers/storage/user_storage_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/in_memory_theme_storage.dart';
import 'support/in_memory_user_storage.dart';

void main() {
  test('GoRouterNotifier sale de checking sin sesión', () async {
    final container = ProviderContainer(
      overrides: [
        userStorageProvider.overrideWithValue(InMemoryUserStorage()),
        themeStorageProvider.overrideWithValue(InMemoryThemeStorage()),
        authSnapshotProvider.overrideWithValue(const AuthSnapshot()),
        initialDarkModeProvider.overrideWithValue(false),
      ],
    );
    addTearDown(container.dispose);
    final sub = container.listen(goRouterProvider, (_, _) {});
    addTearDown(sub.close);

    expect(container.read(goRouterProvider), AuthStatus.checking);

    await Future<void>.delayed(const Duration(milliseconds: 3300));

    expect(container.read(goRouterProvider), AuthStatus.notAuthenticated);
  });

  testWidgets('la app sale del splash y llega al login', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_native_splash'),
          (call) async => null,
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userStorageProvider.overrideWithValue(InMemoryUserStorage()),
          themeStorageProvider.overrideWithValue(InMemoryThemeStorage()),
          authSnapshotProvider.overrideWithValue(const AuthSnapshot()),
          initialDarkModeProvider.overrideWithValue(false),
        ],
        child: const AtmApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Acceso a su cuenta'), findsOneWidget);
  });
}
