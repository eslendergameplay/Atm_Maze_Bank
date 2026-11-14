import 'package:atm_app/config/config.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/providers/auth/auth_snapshot_provider.dart';
import 'package:atm_app/presentation/providers/storage/user_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/in_memory_user_storage.dart';

final _michael = AtmUser.withPassword(
  name: 'Michael De Santa',
  identification: '12345678',
  plainPassword: 'Password1234',
  age: 45,
  balance: 1000,
  banks: const [],
  lastLog: const AtmLog(),
);

ProviderContainer _container({bool withSession = false}) {
  final container = ProviderContainer(
    overrides: [
      userStorageProvider.overrideWithValue(InMemoryUserStorage()),
      authSnapshotProvider.overrideWithValue(
        AuthSnapshot(
          users: [_michael],
          sessionId: withSession ? _michael.identification : null,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('AuthNotifier', () {
    test('inicia con estado checking', () {
      final container = _container();
      expect(container.read(authProvider).authStatus, AuthStatus.checking);
    });

    test('autentica al usuario con credenciales correctas', () async {
      final container = _container();
      await container
          .read(authProvider.notifier)
          .login('12345678', 'Password1234');
      expect(container.read(authProvider).authStatus, AuthStatus.authenticated);
      expect(container.read(authProvider).user?.identification, '12345678');
    });

    test('no autentica con contraseña incorrecta', () async {
      final container = _container();
      await container
          .read(authProvider.notifier)
          .login('12345678', 'WrongPassword');
      expect(container.read(authProvider).authStatus, AuthStatus.checking);
      expect(container.read(authProvider).user, isNull);
    });

    test('no autentica con identificación inexistente', () async {
      final container = _container();
      await container
          .read(authProvider.notifier)
          .login('00000000', 'Password1234');
      expect(container.read(authProvider).authStatus, AuthStatus.checking);
      expect(container.read(authProvider).user, isNull);
    });

    test('registra un nuevo usuario', () async {
      final container = _container();
      final newUser = AtmUser.withPassword(
        name: 'Trevor Philips',
        identification: '11112222',
        plainPassword: 'Password1234',
        age: 35,
        balance: 0,
        banks: const [],
        lastLog: const AtmLog(),
      );
      await container
          .read(authProvider.notifier)
          .register(newUser, 'Password1234');
      expect(container.read(authProvider).users, hasLength(2));
    });

    test('no registra usuario duplicado', () async {
      final container = _container(withSession: true);
      final dupUser = AtmUser.withPassword(
        name: 'Michael Dup',
        identification: '12345678',
        plainPassword: 'Password1234',
        age: 45,
        balance: 0,
        banks: const [],
        lastLog: const AtmLog(),
      );
      await container
          .read(authProvider.notifier)
          .register(dupUser, 'Password1234');
      expect(container.read(authProvider).users, hasLength(1));
    });

    test('logout limpia la sesión', () async {
      final container = _container(withSession: true);
      await container
          .read(authProvider.notifier)
          .login('12345678', 'Password1234');
      expect(container.read(authProvider).authStatus, AuthStatus.authenticated);
      container.read(authProvider.notifier).logout();
      expect(
        container.read(authProvider).authStatus,
        AuthStatus.notAuthenticated,
      );
      expect(container.read(authProvider).user, isNull);
    });

    test('checkAuthStatus devuelve true con sesión válida', () async {
      final container = _container(withSession: true);
      await container
          .read(authProvider.notifier)
          .login('12345678', 'Password1234');
      final result = await container
          .read(authProvider.notifier)
          .checkAuthStatus();
      expect(result, isTrue);
    });

    test('checkAuthStatus devuelve false sin sesión', () async {
      final container = _container();
      final result = await container
          .read(authProvider.notifier)
          .checkAuthStatus();
      expect(result, isFalse);
    });
  });
}
