import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  static const imagePath = 'assets/images/app_cover.png';

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF2D6A3), Color(0xFFF8F4E8), Color(0xFFE8D3AE)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          ColoredBox(color: Theme.of(context).colorScheme.surface.withValues(alpha: .4)),
          SafeArea(top: false, bottom: false, child: child)
        ],
      );
}
