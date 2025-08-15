import 'package:flutter/material.dart';
import 'package:fogospt/utils/extentions/build_context.dart';
import 'package:warnings_core/constants/informational.dart'
    show kContactEmail, kRefreshTimeMinutes;
import 'package:warnings_core/widget/text_partially_url.dart'
    show TextPartiallyUrl;

class AppInformationAboutPage extends StatelessWidget {
  const AppInformationAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sobre")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            TextPartiallyUrl(
              text:
                  context.l10n_fogos.app_information_about_page_data_collected,
              url: context.l10n_fogos.source_agency_website,
              textUrl: context.l10n_fogos.source_agency,
            ),
            Text(
              context.l10n_fogos.app_information_about_page_data_updated(
                context.l10n_fogos.refresh_interval(kRefreshTimeMinutes),
              ),
            ),
            TextPartiallyUrl(
              text: context.l10n_fogos.app_information_about_page_suggestions,
              url: kContactEmail,
              textUrl: kContactEmail,
            ),
            Text(context.l10n_fogos.app_information_about_page_location),
            Text(context.l10n_fogos.app_information_about_made_with_love),
          ],
        ),
      ),
    );
  }
}
