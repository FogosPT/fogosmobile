import 'package:flutter/material.dart';

class AppInformationAboutPage extends StatelessWidget {
  const AppInformationAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sobre")),
      body: Center(child: Text("Sobre a aplicação")),
    );
  }
}
