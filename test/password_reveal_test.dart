import 'package:atm_app/config/config.dart';
import 'package:atm_app/presentation/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(theme: const AppTheme().getTheme(), home: page),
    ),
  );
  await tester.pump(const Duration(milliseconds: 1300));
}

/// El campo de contraseña es el segundo `TextField` del formulario de acceso.
TextField _passwordField(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField).at(1));

void main() {
  testWidgets('el ojo del login alterna la visibilidad de la contraseña', (
    tester,
  ) async {
    await _pump(tester, const LoginPage());

    expect(_passwordField(tester).obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(_passwordField(tester).obscureText, isFalse);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(_passwordField(tester).obscureText, isTrue);

    expect(tester.takeException(), isNull);
  });

  testWidgets('el registro tiene un ojo independiente por contraseña', (
    tester,
  ) async {
    await _pump(tester, const RegisterPage());

    expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.visibility_outlined).first);
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
