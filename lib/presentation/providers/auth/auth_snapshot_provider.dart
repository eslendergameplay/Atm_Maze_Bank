import 'package:atm_app/config/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_snapshot_provider.g.dart';

/// Datos leídos del almacenamiento local antes de `runApp`.
class AuthSnapshot {
  final List<AtmUser> users;
  final String? sessionId;

  const AuthSnapshot({this.users = const [], this.sessionId});
}

/// `main()` lo sobrescribe con lo que devolvió `UserStorage`.
@Riverpod(keepAlive: true)
AuthSnapshot authSnapshot(Ref ref) => const AuthSnapshot();
