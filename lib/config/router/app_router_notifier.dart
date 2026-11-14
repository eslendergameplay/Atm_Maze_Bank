import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router_notifier.g.dart';

@Riverpod(keepAlive: true)
class GoRouterNotifier extends _$GoRouterNotifier {
  @override
  AuthStatus build() {
    // Sincroniza con authProvider: si cambia la sesión, actualiza el estado del router.
    ref.listen(authProvider, (previous, next) {
      if (next.authStatus != state) {
        state = next.authStatus;
      }
    });
    Future.microtask(() => checkInitialAuth());
    return AuthStatus.checking;
  }

  Future<void> checkInitialAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!ref.mounted) return;

    final isAuthenticated = await ref
        .read(authProvider.notifier)
        .checkAuthStatus();

    if (!ref.mounted) return;

    state = isAuthenticated
        ? AuthStatus.authenticated
        : AuthStatus.notAuthenticated;
  }
}
