import 'dart:convert';

import 'package:atm_app/config/config.dart';
import 'package:atm_app/config/security/encrypted_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _usersKey = 'maze_bank.users.v1';
const String _sessionKey = 'maze_bank.session.v1';

/// Contrato de persistencia de las cuentas del cajero (en memoria para pruebas).
abstract class UserStorage {
  Future<List<AtmUser>> loadUsers();

  Future<void> saveUsers(List<AtmUser> users);

  Future<String?> loadSessionId();

  Future<void> saveSessionId(String? identification);

  Future<void> clear();
}

/// Persistencia local de cuentas y sesión con `shared_preferences`.
///
/// Los datos se cifran antes de escribirse en disco para evitar que contraseñas
/// y saldos queden en texto plano.
class SharedPrefsUserStorage implements UserStorage {
  final SharedPreferencesAsync _prefs;

  SharedPrefsUserStorage([SharedPreferencesAsync? prefs])
    : _prefs = prefs ?? SharedPreferencesAsync();

  @override
  Future<List<AtmUser>> loadUsers() async {
    final String? raw = await _prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final String decrypted = EncryptedStorage.decrypt(raw);
      return decodeUsers(decrypted);
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> saveUsers(List<AtmUser> users) async {
    final String json = jsonEncode(users.map(_userToJson).toList());
    final String encrypted = EncryptedStorage.encrypt(json);
    await _prefs.setString(_usersKey, encrypted);
  }

  @override
  Future<String?> loadSessionId() => _prefs.getString(_sessionKey);

  @override
  Future<void> saveSessionId(String? identification) => identification == null
      ? _prefs.remove(_sessionKey)
      : _prefs.setString(_sessionKey, identification);

  @override
  Future<void> clear() async {
    await _prefs.remove(_usersKey);
    await _prefs.remove(_sessionKey);
  }
}

/// Reconstruye las cuentas desde JSON. Un valor nulo o corrupto devuelve `[]`.
List<AtmUser> decodeUsers(String? raw) {
  if (raw == null || raw.isEmpty) return const [];

  try {
    final dynamic decoded = jsonDecode(raw);
    if (decoded is! List) return const [];

    return decoded
        .whereType<Map>()
        .map((entry) => _userFromJson(Map<String, dynamic>.from(entry)))
        .toList();
  } on FormatException {
    return const [];
  }
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

AtmUser _userFromJson(Map<String, dynamic> json) => AtmUser(
  name: _string(json['name'], 'Sin Nombre'),
  identification: _string(json['identification'], 'Sin Identificacion'),
  passwordHash: _string(json['passwordHash'], ''),
  age: _integer(json['age']),
  balance: _decimal(json['balance']),
  banks: _banksFromJson(json['banks']),
  lastLog: _logFromJson(json['lastLog']),
);

/// En los logs solo se guardan referencias (nombre + identificación) para evitar ciclos.
Map<String, dynamic>? _userRefToJson(AtmUser? user) => user == null
    ? null
    : {'name': user.name, 'identification': user.identification};

AtmUser? _userRefFromJson(dynamic value) {
  if (value is! Map) return null;
  final Map<String, dynamic> json = Map<String, dynamic>.from(value);
  if (json['identification'] == null && json['name'] == null) return null;

  return AtmUser(
    name: _string(json['name'], 'Sin Nombre'),
    identification: _string(json['identification'], 'Sin Identificacion'),
  );
}

Map<String, dynamic> _logToJson(AtmLog log) => {
  'origin': _userRefToJson(log.originUser),
  'receiver': _userRefToJson(log.userToReceive),
  'bankName': log.bankName,
  'amount': log.amount,
  'date': log.date?.toIso8601String(),
};

AtmLog _logFromJson(dynamic value) {
  if (value is! Map) return const AtmLog();

  final Map<String, dynamic> json = Map<String, dynamic>.from(value);
  return AtmLog(
    originUser: _userRefFromJson(json['origin']),
    userToReceive: _userRefFromJson(json['receiver']),
    bankName: json['bankName'] is String ? json['bankName'] as String : null,
    amount: json['amount'] is num ? (json['amount'] as num).toDouble() : null,
    date: DateTime.tryParse(_string(json['date'], '')),
  );
}

List<Bank> _banksFromJson(dynamic value) {
  if (value is! List) return const [Bank(name: 'Banco de Venezuela (0102)')];

  return value
      .whereType<Map>()
      .map(
        (entry) => Bank(
          name: _string(Map<String, dynamic>.from(entry)['name'], 'Sin Nombre'),
        ),
      )
      .toList();
}

String _string(dynamic value, String fallback) =>
    value is String ? value : fallback;

int _integer(dynamic value) => value is num ? value.toInt() : 0;

double _decimal(dynamic value) => value is num ? value.toDouble() : 0.0;
