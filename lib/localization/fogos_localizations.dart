import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:intl/intl.dart';

import './generated/l10n/messages_all.dart';

/// In order to generate new arb files we must run
/// `flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/localization/generated/l10n lib/localization/fogos_localizations.dart`
/// To add new files, add the arb files with the `_pt` or other iso code suffix
/// Also, open the file and add this at the top:
///     "@@locale": "pt",
/// After editing and creating the necessary translations we need to run
/// `flutter pub pub run intl_translation:generate_from_arb lib/localization/fogos_localizations.dart lib/localization/generated/l10n/*.arb  --output-dir=lib/localization/generated/l10n`
///
/// For creating new translations, please use the following Live Templates (https://medium.com/flutter-community/live-templates-or-how-to-spend-less-time-writing-boilerplate-code-on-flutter-with-intellij-7fb2f769f23)
///
/// Simple localization:
///
/// ``
///   String get $NAME$ => Intl.message(
///    "$END$",
///    name: '$NAME$',
///    desc: '$DESCRIPTION$',
///  );
/// ```
///
/// Localization with parameter:
///
/// ```
///   String $NAME$(String $VARIABLE$) => Intl.message(
///      "$END$ $$$VARIABLE$",
///      name: '$NAME$',
///      args: [$VARIABLE$],
///      desc: '$DESCRIPTION$',
///      examples: const {'$VARIABLE$' : '$EXAMPLE$'}
///  );
/// ```

class FogosLocalizations {
  const FogosLocalizations();
  // Localized Messages
  String get appTitle => Intl.message(
        "Fogos.pt",
        name: 'appTitle',
        desc: 'App title',
      );

  String get textAbout => Intl.message(
        "Sobre",
        name: 'textAbout',
        desc: 'Texto de about - App Drawer',
      );

  String get textAerealMeans => Intl.message(
        "Meios aéreos",
        name: 'textAerealMeans',
        desc: 'Aereal Means label',
      );

  String get textAerial => Intl.message(
        "Aéreos",
        name: 'textAerial',
        desc: 'Text Aerial',
      );

  String get textBrightness => Intl.message(
        "Luminosidade",
        name: 'textBrightness',
        desc: "Brightness",
      );

  String get textBrightT31 => Intl.message(
        "Bright T31",
        name: 'textBrightT31',
        desc: "Bright T31",
      );

  String get textBrightTi4 => Intl.message(
        "Bright Ti4",
        name: 'textBrightTi4',
        desc: 'Bright Ti 4',
      );

  String get textBrightTi5 => Intl.message(
        "Bright Ti5",
        name: 'textBrightTi5',
        desc: 'Bright Ti 5',
      );

  String get textBugs => Intl.message(
        "Sugestões / Bugs -",
        name: 'textBugs',
        desc: 'Suggestions / Bug reporting -',
      );

  String get textCivilProtection => Intl.message(
        "Página da Protecção Civil Portuguesa.",
        name: 'textCivilProtection',
        desc: 'Portuguese Civil Protection Agency website.',
      );

  String get textConfidence => Intl.message(
        "Confiança",
        name: 'textConfidence',
        desc: "Confidence",
      );

  String get textCounty => Intl.message(
        "Concelho",
        name: 'textCounty',
        desc: 'County Text - List of Counties',
      );

  String get textDataTableCounty => Intl.message(
        "Concelho",
        name: 'textDataTableCounty',
        desc: 'DataTable Country',
      );

  String get textDataTableDistrict => Intl.message(
        "Distrito",
        name: 'textDataTableDistrict',
        desc: 'DataTable District',
      );

  String get textDataTableLocality => Intl.message(
        "Localidade",
        name: 'textDataTableLocality',
        desc: 'DataTable Locality',
      );

  String get textDataTableParish => Intl.message(
        "Freguesia",
        name: 'textDataTableParish',
        desc: 'DataTable Parish',
      );

  String get textDataTableStart => Intl.message(
        "Início",
        name: 'textDataTableStart',
        desc: 'DataTable Start',
      );

  String get textDataTableStatus => Intl.message(
        "Estado",
        name: 'textDataTableStatus',
        desc: 'DataTable Status',
      );

  String get textDataUpdate => Intl.message(
        "Actualizações de 2 em 2 minutos.",
        name: 'textDataUpdate',
        desc: 'Data is updated in 2 minute intervals.',
      );

  String get textDate => Intl.message(
        "Data",
        name: 'textDate',
        desc: 'Data',
      );

  String get textEmptyNotifications => Intl.message(
        "Não tem notificações ativas para fogos",
        name: 'textEmptyNotifications',
        desc: 'Empty Notifications Text',
      );

  String get textFalseAlarm => Intl.message(
        "Falso alarme",
        name: 'textFalseAlarm',
        desc: 'False alarm',
      );

  String get textFalseAlert => Intl.message(
        "Falso alerta",
        name: 'textFalseAlert',
        desc: 'False Alert',
      );

  String get textFirefighters => Intl.message(
        "Operacionais",
        name: 'textFirefighters',
        desc: 'Firefighters',
      );

  String get textFires => Intl.message(
        "Incêndios",
        name: 'textFires',
        desc: 'Text Fires',
      );

  String get textFiresList => Intl.message(
        "Lista de Fogos",
        name: 'textFiresList',
        desc: 'Fires List',
      );

  String get textFiresTable => Intl.message(
        "Tabela de Fogos",
        name: 'textFiresList',
        desc: 'Fires List',
      );

  String get textFireStatusArrival => Intl.message(
        'Chegada ao TO',
        name: 'textFireStatusArrival',
        desc: 'Fire status: arrival',
      );

  String get textFireStatusConclusion => Intl.message(
        'Conclusão',
        name: 'textFireStatusConclusion',
        desc: 'Fire status: conclusion',
      );

  String get textFireStatusDispatch => Intl.message(
        'Despacho',
        name: 'textFireStatusDispatch',
        desc: 'Fire status: Dispatch',
      );

  String get textFireStatusDone => Intl.message(
        'Chegada ao TO',
        name: 'textFireStatusDone',
        desc: 'Fire status: done',
      );

  String get textFireStatusFalseAlarm => Intl.message(
        'Falso Alarme',
        name: 'textFireStatusFalseAlarm',
        desc: 'Fire status: False Alarm',
      );

  String get textFireStatusFalseAlert => Intl.message(
        'Falso Alerta',
        name: 'textFireStatusFalseAlert',
        desc: 'Fire status: False Alert',
      );

  String get textFireStatusFirstAlert => Intl.message(
        'Despacho de 1º Alerta',
        name: 'textFireStatusFirstAlert',
        desc: 'Fire status: first alert dispatch',
      );

  String get textFireStatusOngoing => Intl.message(
        'Em curso',
        name: 'textFireStatusOngoing',
        desc: 'Fire status: ongoing',
      );

  String get textFireStatusResolution => Intl.message(
        'Em resolução',
        name: 'textFireStatusResolution',
        desc: 'Fire status: in resolution',
      );

  String get textFireStatusSignificativeOcurrence => Intl.message(
        'Ocorrência Significativa',
        name: 'textFireStatusSignificativeOcurrence',
        desc: 'Fire status: Significative Ocurrence',
      );

  String get textFireStatusVigilance => Intl.message(
        'Vigilância',
        name: 'textFireStatusVigilance',
        desc: 'Fire status: vigilance',
      );

  String get textFrp => Intl.message("Frp", name: 'textFrp', desc: "Frp");

  String get textHighConfidence => Intl.message(
        "Alta",
        name: 'textHighConfidence',
        desc: "High",
      );

  String get textHumanMeans => Intl.message(
        "Operacionais",
        name: 'textHumanMeans',
        desc: 'Human means label',
      );

  String get textInformationArrival => Intl.message(
        "Chegada ao TO – chegada ao teatro de operações.",
        name: 'textInformationArrival',
        desc: 'Information Screen - Arrival',
      );

  String get textInformationClosed => Intl.message(
        "Encerrada – Entrada, nas respectivas entidades, de todos os meios envolvidos",
        name: 'textInformationClosed',
        desc: 'Information Screen - Closed',
      );

  String get textInformationClosing => Intl.message(
        "Em conclusão – Incêndio extinto, com pequenos focos de combustão dentro do perímetro do incêndio",
        name: 'textInformationClosing',
        desc: 'Information Screen - Closing',
      );

  String get textInformationFirstOrderDispatch => Intl.message(
        "Despacho de 1º alerta – Meios em trânsito para o teatro de operações.",
        name: 'textInformationFirstOrderDispatch',
        desc: 'Information Screen - First Order Dispatch',
      );

  String get textInformationIncidentStatus => Intl.message(
        "Estado das Ocorrências",
        name: 'textInformationIncidentStatus',
        desc: 'Incident Status',
      );

  String get textInformationOngoing => Intl.message(
        "Em curso - Incêndio em evolução sem limitação de área",
        name: 'textInformationOngoing',
        desc: 'Information Screen - Ongoing',
      );

  String get textInformations => Intl.message(
        "Informações",
        name: 'textInformations',
        desc: 'Texto de informações - App Drawer',
      );

  String get textInformationSettling => Intl.message(
        "Em resolução – Incêndio sem perigo de propagação para além do perímetro já atingido",
        name: 'textInformationSettling',
        desc: 'Information Screen - Settling',
      );

  String get textInformationSupervision => Intl.message(
        "Vigilância – Meios no local para actuar em caso de necessidade",
        name: 'textInformationSupervision',
        desc: 'InformationScreen - Supervision',
      );

  String get textInternetConnection => Intl.message(
        "Certifique-se que está ligado à Internet.",
        name: 'textInternetConnection',
        desc: 'Make sure you are connected to the Internet',
      );

  String get textLastNight => Intl.message(
        "Última Noite",
        name: 'textLastNight',
        desc: 'Last Night',
      );

  String get textLastNightStatistics => Intl.message(
        "Estatísticas da última noite",
        name: 'textLastNightStatistics',
        desc: 'Last Night Statísticas',
      );

  String get textLocationApproximate => Intl.message(
        "Localização aproximada.",
        name: 'textLocationApproximate',
        desc: 'Location may not be exact.',
      );

  String get textLowConfidence => Intl.message(
        "Baixa",
        name: 'textLowConfidence',
        desc: "Low",
      );

  String get textMapboxImprove => Intl.message(
        "Melhorar este mapa",
        name: 'textMapboxImprove',
        desc: 'Mapbox Improve Map Label',
      );

  String get textMaximumRisk => Intl.message(
        "Máximo",
        name: 'textMaximumRisk',
        desc: 'Maximum Risk',
      );

  String get textNoConnection => Intl.message(
        "Não foi possível fazer a ligação",
        name: 'textNoConnection',
        desc: 'Warning text for when working offline',
      );

  String get textNominalConfidence => Intl.message(
        "Normal",
        name: 'textNominalConfidence',
        desc: "Nominal",
      );

  String get textNotificationProblems => Intl.message(
        "Se está com problemas em receber notificações, clique no botão abaixo.",
        name: 'textNotificationProblems',
        desc:
            'If you are having problems receiving notifications, click the button below.',
      );

  String get textNotifications => Intl.message(
        "Notificações",
        name: 'textNotifications',
        desc: 'Texto de notificações - App Drawer',
      );

  String get textNow => Intl.message("Agora", name: 'textNow', desc: 'Now');

  String get textOther => Intl.message(
        "Outras",
        name: 'textOther',
        desc: 'Other',
      );

  String get textPartners => Intl.message(
        "Parcerias",
        name: 'textPartners',
        desc: 'Texto de Parcerias - App Drawer',
      );

  String get textPlanes => Intl.message(
        "Aviões",
        name: 'textPlanes',
        desc: 'Notification Text Planes',
      );

  String get textPreviousDays => Intl.message(
        "Últimos Dias",
        name: 'textPreviousDays',
        desc: 'Last Few Days',
      );

  String get textProblemLoadingData => Intl.message(
        "Houve um problema a carregar a informação.",
        name: 'textProblemLoadingData',
        desc: 'There was a problem loading data.',
      );

  String get textRecordsFrom => Intl.message(
        "Registos retirados da",
        name: 'textRecordsFrom',
        desc: 'Data collected From',
      );

  String get textRefreshButton => Intl.message(
        "Refrescar",
        name: 'textRefreshButton',
        desc: 'Text for button refresh, when working offline',
      );

  String get textResetNotifications => Intl.message(
        "Reiniciar notificações",
        name: 'textResetNotifications',
        desc: 'Reset notifications',
      );

  String get textResources => Intl.message(
        "Meios",
        name: 'textResources',
        desc: 'Resources',
      );

  String get textRiskHigh => Intl.message(
        "Elevado",
        name: 'textRiskHigh',
        desc: 'High Risk',
      );

  String get textRiskModerate => Intl.message(
        "Moderado",
        name: 'textRiskModerate',
        desc: 'Risk Moderate',
      );

  String get textRiskOfFire => Intl.message(
        "Risco de Incêndio",
        name: 'textRiskOfFire',
        desc: 'Risk of Fire',
      );

  String get textRiskReduced => Intl.message(
        "Reduzido",
        name: 'textRiskReduced',
        desc: 'Risk reduzed',
      );

  String get textRiskVeryHigh => Intl.message(
        "Muito Elevado",
        name: 'textRiskVeryHigh',
        desc: 'Very high risk',
      );

  String get textSignificatOccurences => Intl.message(
        "Ocorrências significativas",
        name: 'textSignificatOccurences',
        desc: 'Significant Occurences',
      );

  String get textStatistics => Intl.message(
        "Estatísticas",
        name: 'textStatistics',
        desc: 'Texto de estatísticas - App Drawer',
      );

  String get textStatus => Intl.message(
        "Estado",
        name: 'textStatus',
        desc: 'Status label',
      );

  String get textTerrainMeans => Intl.message(
        "Viaturas",
        name: 'textTerrainMeans',
        desc: 'Terrain means label',
      );

  String get textToday => Intl.message(
        "Hoje",
        name: 'textToday',
        desc: 'Today',
      );

  String get textTodayDistricts => Intl.message(
        "Distritos do dia",
        name: 'textTodayDistricts',
        desc: 'Text today Districts',
      );

  String get textTodayInterval => Intl.message(
        "Intervalo do dia",
        name: 'textTodayInterval',
        desc: 'Text today Interval',
      );

  String get textTotal => Intl.message(
        "Total",
        name: 'textTotal',
        desc: 'Total',
      );

  String get textVehicles => Intl.message(
        "Veículos",
        name: 'textVehicles',
        desc: 'Vehicles',
      );

  String get textWarnings => Intl.message(
        "Avisos",
        name: 'textWarnings',
        desc: 'Texto de avisos - App Drawer',
      );

  String get textWarningsMadeira => Intl.message(
        "Avisos Madeira",
        name: 'textWarningsMadeira',
        desc: 'Texto de avisos da Madeira - App Drawer',
      );

  String get textYesterday => Intl.message(
        "Ontem",
        name: 'textYesterday',
        desc: 'Yesterday',
      );

  String get textYesterdayDistricts => Intl.message(
        "Distritos de ontem",
        name: 'textYesterdayDistricts',
        desc: 'Text Yesterday Districts',
      );

  String get textYesterdayInterval => Intl.message(
        "Intervalo de ontem",
        name: 'textYesterdayInterval',
        desc: 'Text Yesterday Interval',
      );

  String textFireStatus(FireStatus status) {
    switch (status) {
      case FireStatus.arrival:
        return textFireStatusArrival;
      case FireStatus.done:
        return textFireStatusDone;
      case FireStatus.first_alert_dispatch:
        return textFireStatusFirstAlert;
      case FireStatus.in_conclusion:
        return textFireStatusConclusion;
      case FireStatus.in_resolution:
        return textFireStatusResolution;
      case FireStatus.ongoing:
        return textFireStatusOngoing;
      case FireStatus.vigilance:
        return textFireStatusVigilance;
      case FireStatus.significative_ocurrence:
        return textFireStatusSignificativeOcurrence;
      case FireStatus.false_alarm:
        return textFireStatusFalseAlarm;
      case FireStatus.false_alert:
        return textFireStatusFalseAlert;
      case FireStatus.dispatch:
        return textFireStatusDispatch;
      default:
        throw Exception('Invalid status: $status');
    }
  }

  String textShare(String? city, String? id) => Intl.message(
        'Incêndio em $city https://fogos.pt/fogo/$id',
        name: 'textShare',
        args: [city ?? '', id ?? ''],
        desc: 'Share Text',
        examples: const {'city': 'Grândola', 'id': '1'},
      );

  /// Initialize localization systems and messages
  static Future<FogosLocalizations> load(Locale locale) async {
    // If we're given "en_US", we'll use it as-is. If we're
    // given "en", we extract it and use it.
    final String localeName =
        locale.countryCode == null || (locale.countryCode?.isEmpty ?? true)
            ? locale.languageCode
            : locale.toString();

    // We make sure the locale name is in the right format e.g.
    // converting "en-US" to "en_US".
    final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);

    // Load localized messages for the current locale.
    await initializeMessages(canonicalLocaleName);
    // We'll uncomment the above line after we've built our messages file

    // Force the locale in Intl.
    Intl.defaultLocale = canonicalLocaleName;

    return FogosLocalizations();
  }

  /// Retrieve localization resources for the widget tree
  /// corresponding to the given `context`
  static FogosLocalizations of(BuildContext context) =>
      Localizations.of<FogosLocalizations>(context, FogosLocalizations)!;
}
