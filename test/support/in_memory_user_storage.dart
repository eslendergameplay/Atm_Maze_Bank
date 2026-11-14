import 'package:atm_app/config/config.dart';
import 'package:atm_app/infraestructure/storage/user_storage.dart';

/// Implementación en memoria de [UserStorage] para pruebas, sin plugins.
class InMemoryUserStorage implements UserStorage {
  List<AtmUser> users;
  String? sessionId;

  InMemoryUserStorage({this.users = const [], this.sessionId});

  @override
  Future<List<AtmUser>> loadUsers() async => users;

  @override
  Future<void> saveUsers(List<AtmUser> users) async {
    this.users = users;
  }

  @override
  Future<String?> loadSessionId() async => sessionId;

  @override
  Future<void> saveSessionId(String? identification) async {
    sessionId = identification;
  }

  @override
  Future<void> clear() async {
    users = const [];
    sessionId = null;
  }
}
