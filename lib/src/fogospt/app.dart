import 'package:flutter/material.dart';
import 'package:fogosmobile/src/fogospt/routing/route.dart';

class FogosApp extends StatelessWidget {
  const FogosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
