// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get fogospt => 'Fogos.pt';

  @override
  String get source_agency =>
      'Autoridade Nacional de Emergência e Proteção Civil';

  @override
  String refresh_interval(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
      zero: 'agora',
    );
    return '$_temp0';
  }

  @override
  String get fires_map_page_notifications => 'Notificações';

  @override
  String get fires_map_page_notifications_list_municipalities =>
      'Notificações por Concelho';

  @override
  String get fires_map_page_fire_list => 'Lista de Incêndios';

  @override
  String get fires_map_page_warnings => 'Avisos';

  @override
  String get fires_map_page_warnings_madeira => 'Avisos Madeira';

  @override
  String get fires_map_page_informations => 'Informações';

  @override
  String get fires_map_page_statistics => 'Estatísticas';

  @override
  String get fires_map_page_about => 'Sobre';

  @override
  String get fires_map_page_partners => 'Parceiros';

  @override
  String get fires_map_page_error => 'Erro ao carregar mapa';

  @override
  String get fires_map_page_more_informations => 'mais informações';

  @override
  String get fires_map_page_local => 'local';

  @override
  String get fires_map_page_state => 'estado';

  @override
  String get fires_map_page_nature => 'natureza';

  @override
  String get fires_map_page_meteo => 'meteo';

  @override
  String get fires_map_page_share => 'partilhar';

  @override
  String get fires_map_page_risk_of_fire => 'risco de incêndio';

  @override
  String get fires_map_page_means_of_transportation => 'meios';

  @override
  String get fires_map_page_start => 'Início';

  @override
  String get partners_page_title => 'Parceiros';

  @override
  String get fire_detail_means => 'meios';

  @override
  String get select_notifications_per_municipality =>
      'Notificações por Concelho';

  @override
  String get select_notifications_per_municipality_error =>
      'Falhou o descarregar da informação do Concelho';

  @override
  String app_information_about_page_data_collected(String agency) {
    return 'Dados recolhidos do site da $agency';
  }

  @override
  String app_information_about_page_data_updated(String interval) {
    return 'Os dados são atualizados a cada $interval.';
  }

  @override
  String get app_information_about_page_location =>
      'A localização pode não ser exata.';

  @override
  String app_information_about_page_suggestions(String email) {
    return 'Sugestões / Reporte de bugs - $email';
  }

  @override
  String get app_information_about_made_with_love => 'Feito com ❤️ por:';
}
