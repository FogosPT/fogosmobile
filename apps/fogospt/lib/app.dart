import 'package:flutter/material.dart';
import 'package:fogospt/routing/route.dart';

class FogosApp extends StatelessWidget {
  const FogosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
