import 'dart:async';
import 'package:flutter/material.dart';
import 'StartPage.dart'; // Import your StartPage here

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _fadeOutController;

  @override
  void initState() {
    super.initState();

    // Fade in (0–1s)
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Scale from 1.2 → 1.0 (0–1s)
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Rotation (1–2s)
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Pulse (shadow/glow) (1–2s)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Fade out to black (2–3s)
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Animation sequence
    _fadeController.forward();
    _scaleController.forward();

    // Delay chained animations
    Future.delayed(const Duration(seconds: 1), () {
      _rotateController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
    });

    // Transition after total 3s
    Future.delayed(const Duration(seconds: 3), () {
      _fadeOutController.forward();
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const StartPage()));
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );

    final scale = Tween<double>(begin: 1.2, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOutCubic),
    );

    final rotation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    final pulse = Tween<double>(begin: 4.0, end: 15.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final fadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOutCubic),
    );

    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                fade,
                scale,
                rotation,
                pulse,
                fadeOut,
              ]),
              builder: (context, child) {
                return Opacity(
                  opacity: fade.value * (1 - fadeOut.value),
                  child: Transform.scale(
                    scale: scale.value,
                    child: Transform.rotate(
                      angle: rotation.value,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Soft pulse glow
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white12.withOpacity(0.2),
                                  blurRadius: pulse.value,
                                  spreadRadius: pulse.value,
                                ),
                              ],
                            ),
                          ),
                          // Logo
                          Image.asset(
                            'lib/assets/logo.png', // your logo path
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          // Optional spinning ring
                          Transform.rotate(
                            angle: _rotateController.value * 6.28,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Fade to black transition
          AnimatedBuilder(
            animation: fadeOut,
            builder: (context, _) =>
                Container(color: Colors.black.withOpacity(fadeOut.value)),
          ),
        ],
      ),
    );
  }
}
