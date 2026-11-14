import 'package:flutter/material.dart';
import 'package:gen_art_bg/gen_art_bg.dart';

/// Fondo corporativo: retícula animada y logo de Maze Bank como marca de agua.
class MazeBankBackground extends StatefulWidget {
  final Widget child;

  const MazeBankBackground({super.key, required this.child});

  @override
  State<MazeBankBackground> createState() => _MazeBankBackgroundState();
}

class _MazeBankBackgroundState extends State<MazeBankBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Marca de agua del logo (muy sutil, no interactiva).
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: isDark ? 0.06 : 0.05,
                child: Image.asset(
                  'assets/logoBank.png',
                  width: 320,
                  fit: BoxFit.contain,
                  color: colorScheme.primary,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),

        // Retícula animada de gen_art_bg.
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: GridPainter(
                    animationValue: _controller.value,
                    gridSize: 12,
                    strokeWidth: 0.0035,
                    color: colorScheme.primary.withValues(
                      alpha: isDark ? 0.16 : 0.10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Degradado para dar profundidad al fondo.
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                    colorScheme.primary.withValues(alpha: isDark ? 0.14 : 0.06),
                  ],
                ),
              ),
            ),
          ),
        ),

        widget.child,
      ],
    );
  }
}
