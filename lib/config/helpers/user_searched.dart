import 'package:atm_app/config/config.dart';
import 'package:atm_app/config/security/password_hasher.dart';

extension AtmUserListExtension on List<AtmUser> {
  /// Busca un usuario por identificación y verifica la contraseña contra su hash.
  AtmUser? findByCredentials(String identification, String plainPassword) {
    try {
      return where(
        (user) =>
            user.identification.toString() == identification &&
            PasswordHasher.verify(plainPassword, user.passwordHash),
      ).firstOrNull;
    } on FormatException {
      // Hash corrupto o inválido: no coincide.
      return null;
    }
  }
}
