import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_background.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key, required this.home});
  final Widget home;

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  Timer? _timer;
  bool _showHome = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showHome = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showHome) return widget.home;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 0.72,
                child: Image.asset(
                  AppBackground.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E9),
                      border: Border.all(color: const Color(0xFFB79558), width: 2),
                      boxShadow: const [BoxShadow(color: Color(0x553C2810), blurRadius: 24, offset: Offset(0, 12))],
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.menu_book_rounded, size: 68, color: Color(0xFF7A5631)),
                            SizedBox(height: 20),
                            Text('رسم الطالب عبد الله', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF49331E))),
                            SizedBox(height: 10),
                            Text('المحتوى الجامع رسم الصحابة وضبط التابع', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, height: 1.8, color: Color(0xFF715C3E))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
