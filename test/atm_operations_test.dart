import 'package:atm_app/config/config.dart';
import 'package:atm_app/config/security/password_hasher.dart';
import 'package:atm_app/presentation/providers/atm/atm_provider.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/providers/storage/user_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/in_memory_user_storage.dart';

final _sender = AtmUser(
  name: 'Michael De Santa',
  identification: '12345678',
  passwordHash: PasswordHasher.hash('Password1234'),
  age: 45,
  balance: 1000,
);

final _receiver = AtmUser(
  name: 'Franklin Clinton',
  identification: '87654321',
  passwordHash: PasswordHasher.hash('Password1234'),
  age: 30,
  balance: 250,
);

/// Sesión autenticada con dos cuentas, sin los `Future.delayed` del login.
class _AuthFake extends AuthNotifier {
  @override
  AuthClass build() => AuthClass(
    authStatus: AuthStatus.authenticated,
    user: _sender,
    users: [_sender, _receiver],
  );
}

ProviderContainer _container([InMemoryUserStorage? storage]) {
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith(_AuthFake.new),
      userStorageProvider.overrideWithValue(
        storage ??
            InMemoryUserStorage(
              users: [_sender, _receiver],
              sessionId: _sender.identification,
            ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('AtmNotifier.deposit', () {
    test('abona el monto al saldo y registra el movimiento', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.deposit(250);

      final state = container.read(atmProvider);
      expect(result, isTrue);
      expect(state.user!.balance, 1250);
      expect(state.logs, hasLength(1));
      expect(state.logs.first.amount, 250);
      expect(state.logs.first.originUser, isNull);
      expect(
        state.logs.first.userToReceive!.identification,
        _sender.identification,
      );
      expect(state.lastLog.amount, 250);
      expect(state.message, contains('éxito'));
      expect(state.isLoading, isFalse);
    });

    test('rechaza montos menores o iguales a cero', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.deposit(0);

      final state = container.read(atmProvider);
      expect(result, isFalse);
      expect(state.user!.balance, _sender.balance);
      expect(state.logs, isEmpty);
      expect(state.message, 'El monto debe ser mayor a cero');
    });
  });

  group('AtmNotifier.withdraw', () {
    test('debita el monto del saldo y registra el retiro', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.withdraw(400);

      final state = container.read(atmProvider);
      expect(result, isTrue);
      expect(state.user!.balance, 600);
      expect(
        state.logs.first.originUser!.identification,
        _sender.identification,
      );
      expect(state.logs.first.userToReceive, isNull);
      expect(state.message, contains('éxito'));
    });

    test('no permite retirar más que el saldo disponible', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.withdraw(5000);

      final state = container.read(atmProvider);
      expect(result, isFalse);
      expect(state.user!.balance, _sender.balance);
      expect(state.logs, isEmpty);
      expect(state.message, contains('Saldo insuficiente'));
    });
  });

  group('AtmNotifier.transfer', () {
    test('debita al origen y deja el destino en el log', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.transfer(_receiver.identification, 300);

      final state = container.read(atmProvider);
      expect(result, isTrue);
      expect(state.user!.balance, 700);
      expect(
        state.logs.first.originUser!.identification,
        _sender.identification,
      );
      expect(
        state.logs.first.userToReceive!.identification,
        _receiver.identification,
      );
      expect(state.message, contains('éxito'));
    });

    test('acredita y guarda el último log en la cuenta destino', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      await notifier.transfer(_receiver.identification, 300);

      final authState = container.read(authProvider);
      final destination = authState.users.firstWhere(
        (user) => user.identification == _receiver.identification,
      );

      expect(destination.balance, _receiver.balance + 300);
      expect(destination.lastLog.amount, 300);
      expect(
        destination.lastLog.originUser!.identification,
        _sender.identification,
      );
      expect(
        destination.lastLog.userToReceive!.identification,
        _receiver.identification,
      );
    });

    test('persiste el saldo del remitente en la lista de usuarios', () async {
      final storage = InMemoryUserStorage(
        users: [_sender, _receiver],
        sessionId: _sender.identification,
      );
      final container = _container(storage);
      final notifier = container.read(atmProvider.notifier);

      await notifier.deposit(200);

      final persisted = container
          .read(authProvider)
          .users
          .firstWhere((user) => user.identification == _sender.identification);

      expect(persisted.balance, _sender.balance + 200);
      expect(persisted.lastLog.amount, 200);
      // También quedó escrito en el almacenamiento local.
      expect(
        storage.users
            .firstWhere((user) => user.identification == _sender.identification)
            .balance,
        _sender.balance + 200,
      );
    });

    test('rechaza una cuenta destino inexistente', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.transfer('00000000', 100);

      final state = container.read(atmProvider);
      expect(result, isFalse);
      expect(state.user!.balance, _sender.balance);
      expect(state.message, 'Cuenta destino no encontrada');
    });

    test('rechaza transferirse a sí mismo', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.transfer(_sender.identification, 100);

      expect(result, isFalse);
      expect(
        container.read(atmProvider).message,
        'No puede transferir a su propia cuenta',
      );
    });

    test('no permite transferir más que el saldo disponible', () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      final result = await notifier.transfer(_receiver.identification, 5000);

      final state = container.read(atmProvider);
      expect(result, isFalse);
      expect(state.user!.balance, _sender.balance);
      expect(state.message, contains('Saldo insuficiente'));
    });
  });

  test(
    'el historial acumula los movimientos con el más reciente primero',
    () async {
      final container = _container();
      final notifier = container.read(atmProvider.notifier);

      await notifier.deposit(100);
      await notifier.withdraw(50);

      final logs = container.read(atmProvider).logs;
      expect(logs, hasLength(2));
      expect(logs.first.userToReceive, isNull);
      expect(logs.last.originUser, isNull);
      expect(container.read(atmProvider).user!.balance, 1050);
    },
  );

  test('al iniciar sesión recupera el último log guardado en la cuenta', () {
    final container = ProviderContainer(
      overrides: [authProvider.overrideWith(_AuthFakeWithLog.new)],
    );
    addTearDown(container.dispose);

    final state = container.read(atmProvider);
    expect(state.user!.identification, '87654321');
    expect(state.logs, hasLength(1));
    expect(state.logs.first.amount, 300);
    expect(state.lastLog.amount, 300);
  });
}

class _AuthFakeWithLog extends AuthNotifier {
  @override
  AuthClass build() {
    final receivedLog = AtmLog(
      originUser: _sender,
      userToReceive: _receiver,
      bankName: 'Maze Bank',
      amount: 300,
    );
    final receiverWithLog = AtmUser(
      name: 'Franklin Clinton',
      identification: '87654321',
      passwordHash: PasswordHasher.hash('Password1234'),
      age: 30,
      balance: 550,
      lastLog: receivedLog,
    );

    return AuthClass(
      authStatus: AuthStatus.authenticated,
      user: receiverWithLog,
      users: [receiverWithLog],
    );
  }
}
