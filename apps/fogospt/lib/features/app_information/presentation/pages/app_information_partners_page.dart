import 'package:flutter/material.dart';
import 'package:fogospt/utils/extentions/build_context.dart';

class AppInformationPartnersPage extends StatelessWidget {
  final List<Image> partners;

  const AppInformationPartnersPage({super.key, required this.partners});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n_fogos.partners_page_title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [...partners],
        ),
      ),
    );
  }
}
