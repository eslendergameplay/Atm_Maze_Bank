import 'package:atm_app/config/config.dart';
import 'package:atm_app/config/security/password_hasher.dart';
import 'package:atm_app/presentation/pages/atm/check_last_log_page.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _passwordHash = PasswordHasher.hash('Password1234');

final _origin = AtmUser(
  name: 'Michael De Santa',
  identification: '12345678',
  passwordHash: _passwordHash,
  age: 45,
  balance: 1000,
);

final _receiver = AtmUser(
  name: 'Franklin Clinton',
  identification: '87654321',
  passwordHash: _passwordHash,
  age: 30,
  balance: 550,
);

final _receivedLog = AtmLog(
  originUser: _origin,
  userToReceive: _receiver,
  bankName: 'Maze Bank',
  amount: 300,
);

final _receiverWithLog = AtmUser(
  name: 'Franklin Clinton',
  identification: '87654321',
  passwordHash: _passwordHash,
  age: 30,
  balance: 550,
  lastLog: _receivedLog,
);

/// Cuenta destino que ya recibió una transferencia antes de iniciar sesión.
class _AuthWithReceivedTransfer extends AuthNotifier {
  @override
  AuthClass build() => AuthClass(
    authStatus: AuthStatus.authenticated,
    user: _receiverWithLog,
    users: [_receiverWithLog],
  );
}

void main() {
  testWidgets('muestra la transferencia recibida guardada en la cuenta', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authProvider.overrideWith(_AuthWithReceivedTransfer.new)],
        child: MaterialApp(
          theme: const AppTheme().getTheme(),
          home: const CheckLastLogPage(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1300));

    expect(tester.takeException(), isNull);
    expect(find.text('Transferencia de Michael De Santa'), findsOneWidget);
    // Al recibirla entra a la cuenta: se muestra como ingreso.
    expect(find.text('+ \$ 300.00'), findsOneWidget);
    // Saldo actualizado en la barra de usuario y en el pie de la tabla.
    expect(find.text('\$ 550.00'), findsNWidgets(2));
  });
}
