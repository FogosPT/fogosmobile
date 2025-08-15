import 'package:flutter/material.dart';
import 'package:fogospt/utils/extentions/build_context.dart';
import 'package:warnings_core/constants/informational.dart'
    show kContactEmail, kRefreshTimeMinutes;

class AppInformationAboutPage extends StatelessWidget {
  const AppInformationAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
// context.l10n_fogos.refresh_interval;
    return Scaffold(
      appBar: AppBar(title: Text("Sobre")),
      body: Column(
        children: [
          Text(
            context.l10n_fogos.app_information_about_page_data_collected(
              context.l10n_fogos.source_agency,
            ),
          ),

          Text(
            context.l10n_fogos.app_information_about_page_data_updated(
              context.l10n_fogos.refresh_interval(kRefreshTimeMinutes),
            ),
          ),
          Text(
            context.l10n_fogos.app_information_about_page_suggestions(
              kContactEmail,
            ),
          ),
          Text(context.l10n_fogos.app_information_about_page_location),
          Text(context.l10n_fogos.app_information_about_made_with_love),
        ],
      ),
    );
  }
}
