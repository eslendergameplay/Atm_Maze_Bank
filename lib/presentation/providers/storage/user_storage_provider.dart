import 'package:atm_app/infraestructure/storage/user_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_storage_provider.g.dart';

/// Almacenamiento de cuentas; `main()` lo sobrescribe con lo leído del disco.
@Riverpod(keepAlive: true)
UserStorage userStorage(Ref ref) => SharedPrefsUserStorage();
