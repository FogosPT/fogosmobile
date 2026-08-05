import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;

  const SplashScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Slight delay so the first frame renders before fade-in
    Future.microtask(() => setState(() => _visible = true));
    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _visible ? _buildSplash() : widget.child,
    );
  }

  Widget _buildSplash() {
    return Scaffold(
      key: const ValueKey('splash'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient SVG
          SvgPicture.asset(
            'assets/SVG/fogos.pt gradiente.svg',
            fit: BoxFit.cover,
          ),

          // Center: Fogos.pt white horizontal logo
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: SvgPicture.asset(
                'assets/SVG/fogos.pt branco horizontal.svg',
                width: 220,
              ),
            ),
          ),

          // Bottom: partner logos side by side
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo-vost.png',
                  height: 28,
                ),
                const SizedBox(width: 24),
                Image.asset(
                  'assets/logo-agif.png',
                  height: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
