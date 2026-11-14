import 'dart:convert';

import 'package:encrypt/encrypt.dart';

/// Encripta y desencripta datos antes de persistirlos en `shared_preferences`.
///
/// Evita que contraseñas y datos sensibles queden en texto plano en el disco del dispositivo.
class EncryptedStorage {
  static final _key = Key.fromUtf8(
    'maze_bank_encryption_key_2026!!!',
  ); // 32 bytes para AES-256
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  /// Encripta [plaintext] y lo devuelve como String base64.
  static String encrypt(String plaintext) =>
      _encrypter.encrypt(plaintext, iv: _iv).base64;

  /// Desencripta [ciphertext] (base64) y devuelve el texto plano.
  static String decrypt(String ciphertext) =>
      _encrypter.decrypt64(ciphertext, iv: _iv);

  /// Encripta un objeto JSON serializado.
  static String encryptJson(Object? object) => encrypt(jsonEncode(object));

  /// Desencripta un String base64 y lo decodifica como JSON dinámico.
  static dynamic decryptJson(String ciphertext) =>
      jsonDecode(decrypt(ciphertext));
}
