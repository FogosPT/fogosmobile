// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get fogospt => 'Fogos.pt';

  @override
  String get source_agency => 'Portuguese Civil Protection Agency';

  @override
  String get source_agency_website => 'https://prociv.gov.pt/en/home/';

  @override
  String refresh_interval(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
      zero: 'now',
    );
    return '$_temp0';
  }

  @override
  String get fires_map_page_notifications => 'Notificações';

  @override
  String get fires_map_page_notifications_list_municipalities =>
      'Notificações por Concelho';

  @override
  String get fires_map_page_fire_list => 'Fire List';

  @override
  String get fires_map_page_warnings => 'Warnings';

  @override
  String get fires_map_page_warnings_madeira => 'Warnings Madeira';

  @override
  String get fires_map_page_informations => 'Informations';

  @override
  String get fires_map_page_statistics => 'Estatistics';

  @override
  String get fires_map_page_about => 'About';

  @override
  String get fires_map_page_partners => 'Partners';

  @override
  String get fires_map_page_error => 'Error loading map';

  @override
  String get fires_map_page_more_informations => 'mais informações';

  @override
  String get fires_map_page_local => 'local';

  @override
  String get fires_map_page_state => 'state';

  @override
  String get fires_map_page_nature => 'nature';

  @override
  String get fires_map_page_meteo => 'meteo';

  @override
  String get fires_map_page_share => 'share';

  @override
  String get fires_map_page_risk_of_fire => 'risk of fire';

  @override
  String get fires_map_page_means_of_transportation => 'means';

  @override
  String get fires_map_page_start => 'Start';

  @override
  String get partners_page_title => 'Partners';

  @override
  String get fire_detail_means => 'Types sent';

  @override
  String get select_notifications_per_municipality =>
      'Notificatonn per Municipality';

  @override
  String get select_notifications_per_municipality_error =>
      'Falhou o descarregar da informação do Concelho';

  @override
  String get app_information_about_page_title => 'About';

  @override
  String get app_information_about_page_data_collected =>
      'Data collected from website of ';

  @override
  String app_information_about_page_data_updated(String interval) {
    return 'Data is updated in $interval intervals.';
  }

  @override
  String get app_information_about_page_location =>
      'Location may not be exact.';

  @override
  String get app_information_about_page_suggestions =>
      'Suggestions / Bug reporting - ';

  @override
  String get app_information_about_made_with_love => 'Made with ❤️ by:';
}
