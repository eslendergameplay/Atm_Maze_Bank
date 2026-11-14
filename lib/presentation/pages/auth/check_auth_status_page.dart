import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:animate_do/animate_do.dart';

/// Pantalla de arranque: muestra la marca mientras el router resuelve la sesión.
class CheckAuthStatusPage extends StatefulWidget {
  const CheckAuthStatusPage({super.key});

  @override
  State<CheckAuthStatusPage> createState() => _CheckAuthStatusPageState();
}

class _CheckAuthStatusPageState extends State<CheckAuthStatusPage> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary,
                    Color.lerp(colorScheme.primary, Colors.black, 0.35)!,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: FadeIn(
              duration: const Duration(milliseconds: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/LogoCompleteBank.png',
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.account_balance,
                        color: colorScheme.primary,
                        size: 72,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'MAZE BANK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'TERMINAL DE AUTOSERVICIO',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Verificando sesión...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Text(
              'Maze Bank © 2026',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initialization() {
    FlutterNativeSplash.remove();
  }
}
