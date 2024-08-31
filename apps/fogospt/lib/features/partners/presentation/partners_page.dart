import 'package:flutter/material.dart';

class PartnersPage extends StatelessWidget {
  final List<Image> partners;

  const PartnersPage({
    super.key,
    required this.partners,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partners'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...partners,
          ],
        ),
      ),
    );
  }
}
