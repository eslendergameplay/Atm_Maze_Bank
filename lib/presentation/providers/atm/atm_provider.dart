import 'package:atm_app/config/config.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'atm_provider.g.dart';

class AtmState {
  final AtmUser? user;
  final AtmLog lastLog;
  final List<AtmLog> logs;
  final List<AtmUser> contacts;
  final String message;
  final bool isLoading;

  AtmState({
    this.user,
    this.lastLog = const AtmLog(
      originUser: AtmUser(),
      userToReceive: AtmUser(),
      bankName: "Sin Banco",
      amount: 0,
    ),
    this.logs = const [],
    this.contacts = const [],
    this.message = '',
    this.isLoading = false,
  });

  AtmState copyWith({
    AtmUser? user,
    AtmLog? lastLog,
    List<AtmLog>? logs,
    List<AtmUser>? contacts,
    String? message,
    bool? isLoading,
  }) => AtmState(
    user: user ?? this.user,
    lastLog: lastLog ?? this.lastLog,
    logs: logs ?? this.logs,
    contacts: contacts ?? this.contacts,
    message: message ?? this.message,
    isLoading: isLoading ?? this.isLoading,
  );
}

@Riverpod(keepAlive: true)
class AtmNotifier extends _$AtmNotifier {
  static const Duration _operationDelay = Duration(milliseconds: 800);

  @override
  AtmState build() {
    final AtmUser? user = ref.read(authProvider).user;

    // Al cambiar la sesión se reinicia el cajero con el último movimiento guardado de la cuenta.
    ref.listen(authProvider, (previous, next) {
      if (next.authStatus == AuthStatus.notAuthenticated) {
        state = AtmState();
        return;
      }

      final AtmUser? nextUser = next.user;
      if (nextUser != null &&
          nextUser.identification != state.user?.identification) {
        state = AtmState(
          user: nextUser,
          lastLog: nextUser.lastLog,
          logs: _seedLogs(nextUser),
        );
      }
    });

    return AtmState(
      user: user,
      lastLog: user?.lastLog ?? const AtmLog(),
      logs: _seedLogs(user),
    );
  }

  /// Abona [amount] al saldo del usuario autenticado.
  Future<bool> deposit(double amount) async {
    if (!_canOperate(amount)) return false;

    state = state.copyWith(isLoading: true, message: '');
    await Future.delayed(_operationDelay);
    if (!ref.mounted) return false;

    final AtmUser user = state.user!;
    final AtmLog log = AtmLog(
      originUser: null,
      userToReceive: user,
      bankName: 'Maze Bank',
      amount: amount,
      date: DateTime.now(),
    );
    final AtmUser updated = _withBalance(user, user.balance + amount, log);

    state = state.copyWith(
      user: updated,
      lastLog: log,
      logs: [log, ...state.logs],
      message: 'Depósito realizado con éxito',
      isLoading: false,
    );
    _syncUser(updated);
    return true;
  }

  /// Retira [amount] del saldo del usuario autenticado.
  Future<bool> withdraw(double amount) async {
    if (!_canOperate(amount)) return false;

    final AtmUser user = state.user!;
    if (amount > user.balance) {
      _fail('Saldo insuficiente para realizar el retiro');
      return false;
    }

    state = state.copyWith(isLoading: true, message: '');
    await Future.delayed(_operationDelay);
    if (!ref.mounted) return false;

    final AtmLog log = AtmLog(
      originUser: user,
      userToReceive: null,
      bankName: 'Maze Bank',
      amount: amount,
      date: DateTime.now(),
    );
    final AtmUser updated = _withBalance(user, user.balance - amount, log);

    state = state.copyWith(
      user: updated,
      lastLog: log,
      logs: [log, ...state.logs],
      message: 'Retiro realizado con éxito',
      isLoading: false,
    );
    _syncUser(updated);
    return true;
  }

  /// Transfiere [amount] del usuario autenticado a [destinationIdentification].
  Future<bool> transfer(String destinationIdentification, double amount) async {
    if (!_canOperate(amount)) return false;

    final AtmUser user = state.user!;
    if (destinationIdentification == user.identification) {
      _fail('No puede transferir a su propia cuenta');
      return false;
    }

    final AtmUser? destination = _findUser(destinationIdentification);
    if (destination == null) {
      _fail('Cuenta destino no encontrada');
      return false;
    }

    if (amount > user.balance) {
      _fail('Saldo insuficiente para realizar la transferencia');
      return false;
    }

    state = state.copyWith(isLoading: true, message: '');
    await Future.delayed(_operationDelay);
    if (!ref.mounted) return false;

    final AtmLog log = AtmLog(
      originUser: user,
      userToReceive: destination,
      bankName: destination.banks.isNotEmpty
          ? destination.banks.first.name
          : 'Maze Bank',
      amount: amount,
      date: DateTime.now(),
    );

    final AtmUser updatedSender = _withBalance(
      user,
      user.balance - amount,
      log,
    );
    // El destino recibe el monto y guarda la transferencia como su último movimiento.
    final AtmUser updatedDestination = _withBalance(
      destination,
      destination.balance + amount,
      log,
    );

    state = state.copyWith(
      user: updatedSender,
      lastLog: log,
      logs: [log, ...state.logs],
      message: 'Transferencia enviada con éxito',
      isLoading: false,
    );
    _syncUser(updatedSender);
    _syncUser(updatedDestination);
    return true;
  }

  void setMessage([String message = '']) {
    state = state.copyWith(message: message);
  }

  void clearMessage() {
    state = state.copyWith(message: '');
  }

  bool _canOperate(double amount) {
    if (state.user == null) {
      _fail('Debe iniciar sesión primero');
      return false;
    }
    if (state.isLoading) return false;
    if (amount <= 0) {
      _fail('El monto debe ser mayor a cero');
      return false;
    }
    return true;
  }

  void _fail(String message) {
    state = state.copyWith(message: message, isLoading: false);
  }

  AtmUser? _findUser(String identification) {
    for (final AtmUser candidate in ref.read(authProvider).users) {
      if (candidate.identification == identification) return candidate;
    }
    return null;
  }

  /// Persiste saldo y último movimiento en `AuthNotifier` (keepAlive) para sobrevivir al logout.
  void _syncUser(AtmUser user) =>
      ref.read(authProvider.notifier).updateUser(user);

  /// Historial inicial: el último movimiento guardado en la cuenta (si existe).
  List<AtmLog> _seedLogs(AtmUser? user) {
    final AtmLog? lastLog = user?.lastLog;
    if (lastLog == null || (lastLog.amount ?? 0) <= 0) return const [];
    return [lastLog];
  }

  /// Los modelos no tienen `copyWith`, así que se reconstruye el usuario.
  AtmUser _withBalance(AtmUser user, double balance, AtmLog lastLog) => AtmUser(
    name: user.name,
    identification: user.identification,
    passwordHash: user.passwordHash,
    age: user.age,
    balance: balance,
    banks: user.banks,
    lastLog: lastLog,
  );
}
