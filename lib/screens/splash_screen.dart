import 'dart:async'; // ← agrega este import
import 'package:flutter/material.dart';
import 'package:flutter_aplicacion1/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _circleScale;
  Timer? _timer; // ← agrega esto

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _logoScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1,
              end: 1.2,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 15,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.2, end: 1),
            weight: 15,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1, end: 1.2),
            weight: 15,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.2,
              end: 0.05,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 15,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
        );

    _circleScale = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // ← reemplaza el Future.delayed por un Timer cancelable
    _timer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => MainScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ← cancela el timer si el widget muere antes
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.white),

          ...List.generate(4, (index) {
            final colors = [const Color(0xFF3F7CAC), const Color(0xFF5478A0)];

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double delay = index * 0.1;

                double scale = Tween<double>(begin: 0, end: 20).evaluate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.5 + delay, 1.0, curve: Curves.easeOut),
                  ),
                );

                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors[index % 2].withOpacity(
                    0.25 + (0.15 * (4 - index)),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _logoScale.value < 0.1 ? 0 : 1,
                child: Transform.scale(scale: _logoScale.value, child: child),
              );
            },
            child: Image.asset('assets/logo.png', width: 170),
          ),
        ],
      ),
    );
  }
}
