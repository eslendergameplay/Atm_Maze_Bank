import 'package:atm_app/config/domain/entities/bank.dart';

List<Bank> getAllBanks() {
  final List<String> bankNames = [
    "Banco de Venezuela (0102)",
    "Venezolano de Crédito (0104)",
    "Banco Mercantil (0105)",
    "BBVA Provincial (0108)",
    "Bancaribe (0114)",
    "Banco Exterior (0115)",
    "Banco Caroní (0128)",
    "Banesco (0134)",
    "Banco Sofitasa (0137)",
    "Mibanco (0138)",
    "Bangente (0146)",
    "BFC Banco Fondo Común (0151)",
    "Del Sur (0156)",
    "Banco del Tesoro (0163)",
    "Banco Agrícola de Venezuela (0166)",
    "Bancrecer (0168)",
    "Mi Banco (0169)",
    "Banco Activo (0171)",
    "Bancamiga (0172)",
    "Banplus (0174)",
    "Banco Bicentenario (0175)",
    "BANFANB (0177)",
    "Instituto Municipal de Crédito Popular (IMCP) (0178/0601)",
  ];

  final List<Bank> banks = bankNames.map((name) => Bank(name: name)).toList();

  return banks;
}
