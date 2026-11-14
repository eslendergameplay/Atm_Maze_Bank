import 'package:atm_app/config/domain/entities/atm_user.dart';

class AtmLog {
  final AtmUser? originUser;
  final AtmUser? userToReceive;
  final String? bankName;
  final double? amount;
  final DateTime? date;

  const AtmLog({
    this.originUser,
    this.userToReceive,
    this.bankName,
    this.amount,
    this.date,
  });
}
