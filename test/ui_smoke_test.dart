import 'package:atm_app/config/config.dart';
import 'package:atm_app/config/security/password_hasher.dart';
import 'package:atm_app/presentation/pages/pages.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget page, {
  AppTheme theme = const AppTheme(),
  bool authenticated = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: authenticated
          ? [authProvider.overrideWith(_AuthenticatedAuthNotifier.new)]
          : const [],
      child: MaterialApp(theme: theme.getTheme(), home: page),
    ),
  );
  // Las animaciones son infinitas, así que se avanza el reloj manualmente.
  await tester.pump(const Duration(milliseconds: 1300));
}

/// Sesión autenticada simulada, sin los `Future.delayed` del login real.
class _AuthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthClass build() {
    final user = AtmUser(
      name: 'Michael De Santa',
      identification: '12345678',
      passwordHash: PasswordHasher.hash('Password1234'),
      age: 45,
      balance: 1500.50,
    );
    return AuthClass(
      authStatus: AuthStatus.authenticated,
      user: user,
      users: [user],
    );
  }
}

void main() {
  final publicPages = <String, Widget>{
    'CheckAuthStatusPage': const CheckAuthStatusPage(),
    'LoginPage': const LoginPage(),
    'RegisterPage': const RegisterPage(),
  };

  final authenticatedPages = <String, Widget>{
    'HomePage': const HomePage(),
    'CheckLastLogPage': const CheckLastLogPage(),
    'NewDepositPage': const NewDepositPage(),
    'NewTransactionPage': const NewTransactionPage(),
    'NewWithdrawPage': const NewWithdrawPage(),
  };

  void registerPageTests(Map<String, Widget> pages, {required bool auth}) {
    for (final entry in pages.entries) {
      testWidgets('${entry.key} renderiza en modo claro', (tester) async {
        await _pump(tester, entry.value, authenticated: auth);
        expect(tester.takeException(), isNull);
      });

      testWidgets('${entry.key} renderiza en modo oscuro', (tester) async {
        await _pump(
          tester,
          entry.value,
          theme: const AppTheme(isDark: true),
          authenticated: auth,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  registerPageTests(publicPages, auth: false);
  registerPageTests(authenticatedPages, auth: true);
}
