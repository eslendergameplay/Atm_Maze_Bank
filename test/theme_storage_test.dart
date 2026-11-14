import 'package:atm_app/presentation/providers/storage/theme_storage_provider.dart';
import 'package:atm_app/presentation/providers/theme/app_theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/in_memory_theme_storage.dart';

ProviderContainer _container({
  bool? initialDark,
  InMemoryThemeStorage? storage,
}) {
  final container = ProviderContainer(
    overrides: [
      initialDarkModeProvider.overrideWithValue(initialDark),
      themeStorageProvider.overrideWithValue(storage ?? InMemoryThemeStorage()),
    ],
  );
  addTearDown(container.dispose);
  // `appThemeProvider` es autoDispose: se mantiene vivo durante la prueba.
  final subscription = container.listen(appThemeProvider, (_, _) {});
  addTearDown(subscription.close);
  return container;
}

void main() {
  test('arranca con el tema guardado en disco', () {
    final container = _container(initialDark: true);

    expect(container.read(appThemeProvider).isDark, isTrue);
  });

  test('sin preferencia guardada arranca en modo claro', () {
    final container = _container();

    expect(container.read(appThemeProvider).isDark, isFalse);
  });

  test('toggleDarkMode cambia el tema y lo persiste', () async {
    final storage = InMemoryThemeStorage(isDark: false);
    final container = _container(initialDark: false, storage: storage);

    container.read(appThemeProvider.notifier).toggleDarkMode();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(appThemeProvider).isDark, isTrue);
    expect(storage.isDark, isTrue);

    container.read(appThemeProvider.notifier).toggleDarkMode();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(appThemeProvider).isDark, isFalse);
    expect(storage.isDark, isFalse);
  });
}
