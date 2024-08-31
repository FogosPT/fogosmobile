import 'package:flutter/material.dart';
import 'package:warnings/warnings.dart';

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
        title: Text(context.l10n.partners_page_title),
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
