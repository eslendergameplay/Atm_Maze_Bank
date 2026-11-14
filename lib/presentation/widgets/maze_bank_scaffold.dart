import 'package:flutter/material.dart';
import 'package:atm_app/presentation/widgets/maze_bank_background.dart';

/// Estructura común: fondo corporativo + cabecera + franja de usuario/saldo.
class MazeBankScaffold extends StatelessWidget {
  final Widget child;
  final bool showHeader;

  const MazeBankScaffold({
    super.key,
    required this.child,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return MazeBankBackground(
      child: Scaffold(backgroundColor: Colors.transparent, body: child),
    );
  }
}
