// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppThemeNotifier)
final appThemeProvider = AppThemeNotifierProvider._();

final class AppThemeNotifierProvider
    extends $NotifierProvider<AppThemeNotifier, AppTheme> {
  AppThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeNotifierHash();

  @$internal
  @override
  AppThemeNotifier create() => AppThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppTheme>(value),
    );
  }
}

String _$appThemeNotifierHash() => r'6adae8c1f03f9a2d0a43a3392c0806abf4aa77c8';

abstract class _$AppThemeNotifier extends $Notifier<AppTheme> {
  AppTheme build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppTheme, AppTheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppTheme, AppTheme>,
              AppTheme,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
