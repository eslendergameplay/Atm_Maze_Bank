import 'dart:async';

import 'package:atm_app/config/config.dart';
import 'package:atm_app/infraestructure/storage/user_storage.dart';
import 'package:atm_app/presentation/providers/auth/auth_snapshot_provider.dart';
import 'package:atm_app/presentation/providers/storage/user_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

/// Centinela para distinguir "no enviado" de un `null` explícito en `copyWith`.
const Object _unset = Object();

class AuthClass {
  final AuthStatus authStatus;
  final List<AtmUser> users;
  final AtmUser? user;
  final String message;

  AuthClass({
    this.authStatus = AuthStatus.checking,
    this.users = const [],
    this.user,
    this.message = '',
  });

  /// Copia el estado; `copyWith(user: null)` cierra la sesión.
  AuthClass copyWith({
    AuthStatus? authStatus,
    List<AtmUser>? users,
    Object? user = _unset,
    String? message,
  }) => AuthClass(
    authStatus: authStatus ?? this.authStatus,
    users: users ?? this.users,
    user: identical(user, _unset) ? this.user : user as AtmUser?,
    message: message ?? this.message,
  );
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthClass build() {
    final AuthSnapshot snapshot = ref.watch(authSnapshotProvider);

    return AuthClass(
      users: snapshot.users,
      user: _findByIdentification(snapshot.users, snapshot.sessionId),
    );
  }

  Future<bool> checkAuthStatus() async {
    await Future.delayed(Duration(milliseconds: 800));
    if (state.user == null) {
      setMessage('Debe iniciar sesion primero');
      return false;
    }
    if (state.user != null && (state.users.contains(state.user))) {
      setMessage('Sesion Iniciada');
      return true;
    }
    await Future.delayed(Duration(milliseconds: 800));
    setMessage('Sesion Expirada');
    return false;
  }

  Future<void> login(String identification, String password) async {
    await Future.delayed(Duration(milliseconds: 800));

    final AtmUser? userExist = state.users.findByCredentials(
      identification,
      password,
    );

    if (userExist == null) {
      setMessage('Credenciales Incorrectas');
      return;
    }

    _setRegisterUser(userExist, 'Ingreso Exitoso!!');
    await Future.delayed(Duration(milliseconds: 800));
  }

  Future<void> register(AtmUser user, String plainPassword) async {
    await Future.delayed(Duration(milliseconds: 800));
    final AtmUser? userExist = state.users.findByCredentials(
      user.identification.toString(),
      plainPassword,
    );

    if (userExist != null) {
      setMessage('EL usario ya existe en el sistema');
      return;
    }

    state = state.copyWith(users: [...state.users, user]);
    _setRegisterUser(user, 'Registro Exitoso');
    await Future.delayed(Duration(milliseconds: 800));
  }

  /// Reemplaza un usuario de `users` y, si es el activo, también la sesión.
  void updateUser(AtmUser user) {
    final List<AtmUser> users = state.users
        .map((u) => u.identification == user.identification ? user : u)
        .toList();

    if (users.isEmpty) return;

    final bool isCurrent = state.user?.identification == user.identification;

    // Solo se reemplaza la sesión si la cuenta actualizada es la activa.
    state = isCurrent
        ? state.copyWith(users: users, user: user)
        : state.copyWith(users: users);
    _persist();
  }

  void _setRegisterUser(AtmUser user, String message) {
    state = state.copyWith(
      user: user,
      message: message,
      authStatus: AuthStatus.authenticated,
    );
    _persist();
    checkAuthStatus();
  }

  void logout() {
    state = state.copyWith(user: null, authStatus: AuthStatus.notAuthenticated);
    _persist();
    checkAuthStatus();
  }

  void setMessage([String message = '']) {
    state = state.copyWith(message: message);
  }

  void clearMessage() {
    state = state.copyWith(message: '');
  }

  AtmUser? _findByIdentification(List<AtmUser> users, String? identification) {
    if (identification == null) return null;
    for (final AtmUser user in users) {
      if (user.identification == identification) return user;
    }
    return null;
  }

  /// Guarda cuentas y sesión en local; fallar no interrumpe la operación del cajero.
  void _persist() {
    final UserStorage storage = ref.read(userStorageProvider);
    // `checking` = sesión restaurada al arrancar; solo se borra tras un logout explícito.
    final String? sessionId = state.authStatus == AuthStatus.notAuthenticated
        ? null
        : state.user?.identification;

    unawaited(storage.saveUsers(state.users).catchError((Object _) {}));
    unawaited(storage.saveSessionId(sessionId).catchError((Object _) {}));
  }
}
