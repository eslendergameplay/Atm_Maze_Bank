import 'package:bcrypt/bcrypt.dart';

/// Utilidad para hashear y verificar contraseñas con bcrypt.
///
/// Las contraseñas nunca se almacenan ni comparan en texto plano:
/// se guarda el hash bcrypt y se verifica contra él.
class PasswordHasher {
  /// Genera un hash bcrypt de [plainPassword].
  static String hash(String plainPassword) {
    final salt = BCrypt.gensalt();
    return BCrypt.hashpw(plainPassword, salt);
  }

  /// Verifica si [plainPassword] coincide con el [storedHash].
  static bool verify(String plainPassword, String storedHash) =>
      BCrypt.checkpw(plainPassword, storedHash);
}
