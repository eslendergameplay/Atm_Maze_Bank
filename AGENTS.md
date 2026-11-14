# atm_app

Flutter ATM simulator with a Spanish UI and **no backend**. "Persistence" is in-memory Riverpod state with artificial `Future.delayed` calls in `lib/presentation/providers/auth/auth_provider.dart`. Don't add HTTP clients, databases, or auth services unless asked.

## Commands

Run from this directory. The git repo root is `C:\Users\Usuario`, not this folder, so `git status` shows the whole project as untracked — stage explicit paths, never `git add .` / `git commit -a`.

```bash
flutter pub get
dart run build_runner watch -d   # regenerate *.g.dart after editing @riverpod classes
flutter analyze                  # baseline: 12 issues (info-level + 1 asset warning), exit code 1
flutter test                     # no test/ directory exists yet
flutter run -d windows           # desktop/web/android/ios targets are all generated
```

- `.g.dart` files are committed and sit next to their sources; `build_runner` is required after adding/changing any `@riverpod` provider or `part '*.g.dart'` file.
- `flutter analyze` currently reports 11 style infos (missing braces, one unnecessary import) and one warning: `assets/` is declared in `pubspec.yaml` but **does not exist**. Treat new warnings as regressions; don't chase the existing baseline.
- `analysis_options.yaml` lints only `lib/`; platform folders are excluded.

## Layout (non-obvious parts)

- `lib/config/` — domain entities (`domain/entities`), static data (`helpers/banks_list.dart`), router, theme.
- `lib/infraestructure/inputs/` — Formz validators (`Identification`, `Password`, `PasswordR`, `Name`, `Age`, `Amount`). The misspelling `infraestructure` is the real directory name; keep it.
- `lib/presentation/providers/` — Riverpod notifiers plus `auth/form/` and `atm/form/` form state, which combine Formz validation with `isPosting`/`isFormPosted` flags.
- Import aggregation is `package:atm_app/config/config.dart`, which re-exports entities, helpers, router, and theme.
- `login_form.dart` is the pattern to copy for new forms (`_touchEveryField`, `Formz.validate`, `ref.mounted` guard before updating state in `finally`).

## Current wiring state (don't "fix" blindly)

- `lib/main.dart` is still the Flutter template (`Hello World`) and never mounts the router. The real graph is `AppRouterNotifier` (`lib/config/router/`), `AuthNotifier`, `AtmNotifier`, and the `CheckAuthStatusPage` splash flow.
- The router redirects authenticated users to `/home`, but **`/home` is not registered** and `lib/presentation/pages/atm/home_page.dart` is empty. Other pages are stubs too (`LoginPage` returns `Container()`).
- `lib/presentation/providers/providers.dart` is an empty barrel (unlike `pages/pages.dart` and `widgets/widgets.dart`, which do export). `lib/presentation/providers/atm_provider.dart` is also an empty leftover; the real provider is `providers/atm/atm_provider.dart`.
- `AtmNotifier.build()` does `ref.read(authProvider).user!` — it assumes a logged-in user, so only read it behind authenticated routes.

## Conventions

- All UI text, messages, and validation errors are Spanish (e.g. `'Credenciales Incorrectas'`); keep new strings Spanish and match existing phrasing/typos in messages.
- Entities are immutable with defaults (`AtmUser`, `AtmLog`, `Bank`) and manual `copyWith`; there is no `json_serializable`/freezed. Follow the same pattern.
- Auth status is the `AuthStatus` enum (`checking` / `authenticated` / `notAuthenticated`), mirrored into `GoRouterNotifier` (a Riverpod notifier mixed with `ChangeNotifier` for `refreshListenable`).
- The bank catalog comes from `getAllBanks()` in `lib/config/helpers/banks_list.dart`; `user_searched.dart` adds the `findByCredentials` extension used for login lookup. Extend those instead of hardcoding lists or lookups in pages.
