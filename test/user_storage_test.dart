import 'dart:convert';

import 'package:atm_app/config/config.dart';
import 'package:atm_app/config/security/password_hasher.dart';
import 'package:atm_app/config/security/encrypted_storage.dart';
import 'package:atm_app/infraestructure/storage/user_storage.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/providers/auth/auth_snapshot_provider.dart';
import 'package:atm_app/presentation/providers/storage/user_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/in_memory_user_storage.dart';

final _passwordHash = PasswordHasher.hash('Password1234');

final _michael = AtmUser(
  name: 'Michael De Santa',
  identification: '12345678',
  passwordHash: _passwordHash,
  age: 45,
  balance: 1500.50,
  banks: [Bank(name: 'Maze Bank')],
);

final _log = AtmLog(
  originUser: const AtmUser(
    name: 'Franklin Clinton',
    identification: '87654321',
  ),
  userToReceive: const AtmUser(
    name: 'Michael De Santa',
    identification: '12345678',
  ),
  bankName: 'Maze Bank',
  amount: 300,
  date: DateTime(2026, 1, 2, 3, 4, 5),
);

ProviderContainer _container(InMemoryUserStorage storage) {
  final container = ProviderContainer(
    overrides: [
      userStorageProvider.overrideWithValue(storage),
      authSnapshotProvider.overrideWithValue(
        AuthSnapshot(users: storage.users, sessionId: storage.sessionId),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('serialización de cuentas', () {
    test('ida y vuelta conserva la cuenta, sus bancos y el último log', () {
      final user = AtmUser(
        name: _michael.name,
        identification: _michael.identification,
        passwordHash: _michael.passwordHash,
        age: _michael.age,
        balance: _michael.balance,
        banks: _michael.banks,
        lastLog: _log,
      );
      const other = AtmUser(
        name: 'Trevor Philips',
        identification: '11112222',
        balance: 0,
      );

      // Cifrar y descifrar usando el flujo real de EncryptedStorage
      final json = jsonEncode([_userToJson(user), _userToJson(other)]);
      final encrypted = EncryptedStorage.encrypt(json);
      final decrypted = EncryptedStorage.decrypt(encrypted);
      final decoded = decodeUsers(decrypted);

      expect(decoded, hasLength(2));
      final restored = decoded.first;
      expect(restored.name, 'Michael De Santa');
      expect(restored.identification, '12345678');
      expect(restored.passwordHash, _passwordHash);
      expect(restored.age, 45);
      expect(restored.balance, 1500.50);
      expect(restored.banks.single.name, 'Maze Bank');

      expect(restored.lastLog.amount, 300);
      expect(restored.lastLog.bankName, 'Maze Bank');
      expect(restored.lastLog.date, DateTime(2026, 1, 2, 3, 4, 5));
      expect(restored.lastLog.originUser!.name, 'Franklin Clinton');
      expect(restored.lastLog.userToReceive!.identification, '12345678');

      expect(decoded.last.name, 'Trevor Philips');
      expect(decoded.last.lastLog.amount, isNull);
    });

    test('datos vacíos o corruptos devuelven una lista vacía', () {
      expect(decodeUsers(null), isEmpty);
      expect(decodeUsers(''), isEmpty);
      expect(decodeUsers('esto no es json'), isEmpty);
      expect(decodeUsers('{"users": []}'), isEmpty);
    });

    test('datos cifrados descifran correctamente', () {
      final json = jsonEncode([_userToJson(_michael)]);
      final encrypted = EncryptedStorage.encrypt(json);
      final decrypted = EncryptedStorage.decrypt(encrypted);
      final decoded = decodeUsers(decrypted);

      expect(decoded, hasLength(1));
      expect(decoded.first.passwordHash, _passwordHash);
    });
  });

  group('AuthNotifier con almacenamiento local', () {
    test('arranca con las cuentas y la sesión guardadas', () {
      final storage = InMemoryUserStorage(
        users: [_michael],
        sessionId: _michael.identification,
      );
      final container = _container(storage);

      final state = container.read(authProvider);
      expect(state.users, hasLength(1));
      expect(state.user!.identification, _michael.identification);
      expect(state.authStatus, AuthStatus.checking);
    });

    test('sin sesión guardada arranca sin usuario autenticado', () {
      final container = _container(InMemoryUserStorage(users: [_michael]));

      expect(container.read(authProvider).user, isNull);
    });

    test('updateUser persiste el saldo y mantiene la sesión', () {
      final storage = InMemoryUserStorage(
        users: [_michael],
        sessionId: _michael.identification,
      );
      final container = _container(storage);

      container
          .read(authProvider.notifier)
          .updateUser(
            AtmUser(
              name: 'Michael De Santa',
              identification: '12345678',
              passwordHash: _passwordHash,
              age: 45,
              balance: 1750.50,
            ),
          );

      expect(storage.users.single.balance, 1750.50);
      expect(storage.sessionId, _michael.identification);
      expect(container.read(authProvider).user!.balance, 1750.50);
    });

    test('logout borra la sesión pero conserva las cuentas', () async {
      final storage = InMemoryUserStorage(
        users: [_michael],
        sessionId: _michael.identification,
      );
      final container = _container(storage);

      container.read(authProvider.notifier).logout();
      // `checkAuthStatus()` corre en segundo plano; se espera a que termine.
      await Future<void>.delayed(const Duration(milliseconds: 900));

      expect(storage.sessionId, isNull);
      expect(storage.users, hasLength(1));
    });
  });
}

Map<String, dynamic> _userToJson(AtmUser user) => {
  'name': user.name,
  'identification': user.identification,
  'passwordHash': user.passwordHash,
  'age': user.age,
  'balance': user.balance,
  'banks': user.banks.map((bank) => {'name': bank.name}).toList(),
  'lastLog': _logToJson(user.lastLog),
};

Map<String, dynamic>? _logToJson(AtmLog log) => {
  'origin': log.originUser == null
      ? null
      : {
          'name': log.originUser!.name,
          'identification': log.originUser!.identification,
        },
  'receiver': log.userToReceive == null
      ? null
      : {
          'name': log.userToReceive!.name,
          'identification': log.userToReceive!.identification,
        },
  'bankName': log.bankName,
  'amount': log.amount,
  'date': log.date?.toIso8601String(),
};
