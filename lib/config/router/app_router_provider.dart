import 'package:atm_app/config/router/app_router_notifier.dart';
import 'package:atm_app/presentation/pages/pages.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router_provider.g.dart';

@Riverpod(keepAlive: true)
class AppRouterNotifier extends _$AppRouterNotifier {
  final ValueNotifier<bool> _routerRefresh = ValueNotifier<bool>(false);

  @override
  GoRouter build() {
    // Cuando cambie el estado de autenticación, notifica a GoRouter para que re-evalúe el redirect.
    ref.listen(goRouterProvider, (previous, next) {
      _routerRefresh.value = !_routerRefresh.value;
    });

    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: _routerRefresh,
      routes: <GoRoute>[
        GoRoute(
          path: '/splash',
          builder: (context, state) => CheckAuthStatusPage(),
        ),
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/home', builder: (context, state) => HomePage()),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
        GoRoute(
          path: '/checkLog',
          builder: (context, state) => CheckLastLogPage(),
        ),
        GoRoute(
          path: '/newDeposit',
          builder: (context, state) => NewDepositPage(),
        ),
        GoRoute(
          path: '/newTransaction',
          builder: (context, state) => NewTransactionPage(),
        ),
        GoRoute(
          path: '/NewWithdraw',
          builder: (context, state) => NewWithdrawPage(),
        ),
      ],
      redirect: (context, state) {
        final isGoingTo = state.matchedLocation;
        final authStatus = ref.read(goRouterProvider);

        if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
          return null;
        }

        if (authStatus == AuthStatus.notAuthenticated) {
          if (isGoingTo == '/login' || isGoingTo == '/register') return null;
          return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/splash') {
            return '/home';
          }
        }
        return null;
      },
    );
  }
}
