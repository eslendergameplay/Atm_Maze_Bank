import 'package:atm_app/config/domain/entities/atm_log.dart';
import 'package:atm_app/config/domain/entities/bank.dart';
import 'package:atm_app/config/security/password_hasher.dart';

class AtmUser {
  final String name;
  final String identification;
  final String passwordHash;
  final int age;
  final double balance;
  final List<Bank> banks;
  final AtmLog lastLog;

  const AtmUser({
    this.name = "Sin Nombre",
    this.age = 0,
    this.identification = 'Sin Identificacion',
    this.passwordHash = '',
    this.balance = 0.0,
    this.banks = const [Bank(name: "Banco de Venezuela (0102)")],
    this.lastLog = const AtmLog(),
  });

  /// Crea un usuario con la contraseña hasheada.
  factory AtmUser.withPassword({
    required String name,
    required String identification,
    required String plainPassword,
    required int age,
    required double balance,
    required List<Bank> banks,
    required AtmLog lastLog,
  }) => AtmUser(
    name: name,
    identification: identification,
    passwordHash: PasswordHasher.hash(plainPassword),
    age: age,
    balance: balance,
    banks: banks,
    lastLog: lastLog,
  );
}
