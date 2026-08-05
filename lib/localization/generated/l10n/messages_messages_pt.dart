// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages_pt locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages_pt';

  static m0(city, id) => "Incêndio em ${city} https://fogos.pt/fogo/${id}";
  static m1(km) => "Será notificado quando um novo incêndio ocorrer dentro de ${km} km da sua localização.";
  static m2(distance) => "🔥 Incêndio a ${distance} de si";
  static m3(distance) => "${distance} km do incidente";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("Fogos.pt"),
    "textAbout" : MessageLookupByLibrary.simpleMessage("Sobre"),
    "textAerealMeans" : MessageLookupByLibrary.simpleMessage("Meios aéreos"),
    "textAerial" : MessageLookupByLibrary.simpleMessage("Aéreos"),
    "textBugs" : MessageLookupByLibrary.simpleMessage("Sugestões / Bugs -"),
    "textCivilProtection" : MessageLookupByLibrary.simpleMessage("Página da Protecção Civil Portuguesa."),
    "textCounty" : MessageLookupByLibrary.simpleMessage("Concelho"),
    "textDataTableCounty" : MessageLookupByLibrary.simpleMessage("Concelho"),
    "textDataTableDistrict" : MessageLookupByLibrary.simpleMessage("Distrito"),
    "textDataTableLocality" : MessageLookupByLibrary.simpleMessage("Localidade"),
    "textDataTableParish" : MessageLookupByLibrary.simpleMessage("Freguesia"),
    "textDataTableStart" : MessageLookupByLibrary.simpleMessage("Início"),
    "textDataTableStatus" : MessageLookupByLibrary.simpleMessage("Estado"),
    "textDataUpdate" : MessageLookupByLibrary.simpleMessage("Actualizações de 2 em 2 minutos."),
    "textBrightT31" : MessageLookupByLibrary.simpleMessage("Bright T31"),
    "textBrightTi4" : MessageLookupByLibrary.simpleMessage("Bright Ti4"),
    "textBrightTi5" : MessageLookupByLibrary.simpleMessage("Bright Ti5"),
    "textBrightness" : MessageLookupByLibrary.simpleMessage("Luminosidade"),
    "textConfidence" : MessageLookupByLibrary.simpleMessage("Confiança"),
    "textDate" : MessageLookupByLibrary.simpleMessage("Data"),
    "textEmptyNotifications" : MessageLookupByLibrary.simpleMessage("Não tem notificações ativas para fogos"),
    "textFalseAlarm" : MessageLookupByLibrary.simpleMessage("Falso alarme"),
    "textFalseAlert" : MessageLookupByLibrary.simpleMessage("Falso alerta"),
    "textFireStatusArrival" : MessageLookupByLibrary.simpleMessage("Chegada ao TO"),
    "textFireStatusConclusion" : MessageLookupByLibrary.simpleMessage("Conclusão"),
    "textFireStatusDispatch" : MessageLookupByLibrary.simpleMessage("Despacho"),
    "textFireStatusDone" : MessageLookupByLibrary.simpleMessage("Chegada ao TO"),
    "textFireStatusFalseAlarm" : MessageLookupByLibrary.simpleMessage("Falso Alarme"),
    "textFireStatusFalseAlert" : MessageLookupByLibrary.simpleMessage("Falso Alerta"),
    "textFireStatusFirstAlert" : MessageLookupByLibrary.simpleMessage("Despacho de 1º Alerta"),
    "textFireStatusOngoing" : MessageLookupByLibrary.simpleMessage("Em curso"),
    "textFireStatusResolution" : MessageLookupByLibrary.simpleMessage("Em resolução"),
    "textFireStatusSignificativeOcurrence" : MessageLookupByLibrary.simpleMessage("Ocorrência Significativa"),
    "textFireStatusVigilance" : MessageLookupByLibrary.simpleMessage("Vigilância"),
    "textFirefighters" : MessageLookupByLibrary.simpleMessage("Operacionais"),
    "textFires" : MessageLookupByLibrary.simpleMessage("Incêndios"),
    "textFiresList" : MessageLookupByLibrary.simpleMessage("Lista de Fogos"),
    "textSearch" : MessageLookupByLibrary.simpleMessage("Pesquisa"),
    "textAllIncidents" : MessageLookupByLibrary.simpleMessage("Todas as Ocorrências"),
    "textOtherFires" : MessageLookupByLibrary.simpleMessage("Outros Fogos"),
    "textHumanMeans" : MessageLookupByLibrary.simpleMessage("Operacionais"),
    "textInformationArrival" : MessageLookupByLibrary.simpleMessage("Chegada ao TO – chegada ao teatro de operações."),
    "textInformationClosed" : MessageLookupByLibrary.simpleMessage("Encerrada – Entrada, nas respectivas entidades, de todos os meios envolvidos"),
    "textInformationClosing" : MessageLookupByLibrary.simpleMessage("Em conclusão – Incêndio extinto, com pequenos focos de combustão dentro do perímetro do incêndio"),
    "textInformationFirstOrderDispatch" : MessageLookupByLibrary.simpleMessage("Despacho de 1º alerta – Meios em trânsito para o teatro de operações."),
    "textInformationIncidentStatus" : MessageLookupByLibrary.simpleMessage("Estado das Ocorrências"),
    "textInformationOngoing" : MessageLookupByLibrary.simpleMessage("Em curso - Incêndio em evolução sem limitação de área"),
    "textInformationSettling" : MessageLookupByLibrary.simpleMessage("Em resolução – Incêndio sem perigo de propagação para além do perímetro já atingido"),
    "textInformationSupervision" : MessageLookupByLibrary.simpleMessage("Vigilância – Meios no local para actuar em caso de necessidade"),
    "textInformations" : MessageLookupByLibrary.simpleMessage("Informações"),
    "textInternetConnection" : MessageLookupByLibrary.simpleMessage("Certifique-se que está ligado à Internet."),
    "textLastNight" : MessageLookupByLibrary.simpleMessage("Última Noite"),
    "textLastNightStatistics" : MessageLookupByLibrary.simpleMessage("Estatísticas da última noite"),
    "textLocationApproximate" : MessageLookupByLibrary.simpleMessage("Localização aproximada."),
    "textMapboxImprove" : MessageLookupByLibrary.simpleMessage("Melhorar este mapa"),
    "textMaximumRisk" : MessageLookupByLibrary.simpleMessage("Máximo"),
    "textNoConnection" : MessageLookupByLibrary.simpleMessage("Não foi possível fazer a ligação"),
    "textNotificationProblems" : MessageLookupByLibrary.simpleMessage("Se está com problemas em receber notificações, clique no botão abaixo."),
    "textNotifications" : MessageLookupByLibrary.simpleMessage("Notificações"),
    "textNow" : MessageLookupByLibrary.simpleMessage("Agora"),
    "textOther" : MessageLookupByLibrary.simpleMessage("Outras"),
    "textPartners" : MessageLookupByLibrary.simpleMessage("Parcerias"),
    "textPlanes" : MessageLookupByLibrary.simpleMessage("Aviões"),
    "textPreviousDays" : MessageLookupByLibrary.simpleMessage("Últimos Dias"),
    "textProblemLoadingData" : MessageLookupByLibrary.simpleMessage("Houve um problema a carregar a informação."),
    "textRecordsFrom" : MessageLookupByLibrary.simpleMessage("Registos retirados da"),
    "textRefreshButton" : MessageLookupByLibrary.simpleMessage("Refrescar"),
    "textResetNotifications" : MessageLookupByLibrary.simpleMessage("Reiniciar notificações"),
    "textResources" : MessageLookupByLibrary.simpleMessage("Meios"),
    "textRiskHigh" : MessageLookupByLibrary.simpleMessage("Elevado"),
    "textRiskModerate" : MessageLookupByLibrary.simpleMessage("Moderado"),
    "textRiskOfFire" : MessageLookupByLibrary.simpleMessage("Perigo de Incêndio"),
    "textRiskReduced" : MessageLookupByLibrary.simpleMessage("Reduzido"),
    "textRiskVeryHigh" : MessageLookupByLibrary.simpleMessage("Muito Elevado"),
    "textShare" : m0,
    "textSignificatOccurences" : MessageLookupByLibrary.simpleMessage("Ocorrências significativas"),
    "textStatistics" : MessageLookupByLibrary.simpleMessage("Estatísticas"),
    "textStatus" : MessageLookupByLibrary.simpleMessage("Estado"),
    "textTerrainMeans" : MessageLookupByLibrary.simpleMessage("Viaturas"),
    "textToday" : MessageLookupByLibrary.simpleMessage("Hoje"),
    "textTodayDistricts" : MessageLookupByLibrary.simpleMessage("Distritos do dia"),
    "textTodayInterval" : MessageLookupByLibrary.simpleMessage("Intervalo do dia"),
    "textTotal" : MessageLookupByLibrary.simpleMessage("Total"),
    "textVehicles" : MessageLookupByLibrary.simpleMessage("Veículos"),
    "textWarnings" : MessageLookupByLibrary.simpleMessage("Avisos"),
    "textWarningsMadeira" : MessageLookupByLibrary.simpleMessage("Avisos Madeira"),
    "textYesterday" : MessageLookupByLibrary.simpleMessage("Ontem"),
    "textYesterdayDistricts" : MessageLookupByLibrary.simpleMessage("Distritos de ontem"),
    "textYesterdayInterval" : MessageLookupByLibrary.simpleMessage("Intervalo de ontem"),
    "nearbyChannelName" : MessageLookupByLibrary.simpleMessage("Incêndios Próximos"),
    "nearbyChannelDescription" : MessageLookupByLibrary.simpleMessage("Notificações de incêndios próximos da sua localização"),
    "textNearbyNotifications" : MessageLookupByLibrary.simpleMessage("Notificações por proximidade"),
    "textNearbyNotificationsSubtitle" : MessageLookupByLibrary.simpleMessage("Receba alertas quando um novo incêndio ocorrer perto de si"),
    "textNearbyPrivacyNotice" : MessageLookupByLibrary.simpleMessage("A sua localização nunca é enviada para os nossos servidores. O cálculo de proximidade é feito exclusivamente no seu dispositivo."),
    "textNearbyAlertRadius" : MessageLookupByLibrary.simpleMessage("Raio de alerta"),
    "textNearbyRadiusDescription" : m1,
    "textNearbyIncidentType" : MessageLookupByLibrary.simpleMessage("Tipo de ocorrências"),
    "textNearbyFiresOnly" : MessageLookupByLibrary.simpleMessage("Apenas incêndios"),
    "textNearbyFiresOnlySubtitle" : MessageLookupByLibrary.simpleMessage("Incêndios rurais, urbanos e de transporte"),
    "textNearbyAllIncidents" : MessageLookupByLibrary.simpleMessage("Todos os incidentes"),
    "textNearbyAllIncidentsSubtitle" : MessageLookupByLibrary.simpleMessage("Incêndios, acidentes e outras ocorrências"),
    "textNearbyLocationPermissionRequired" : MessageLookupByLibrary.simpleMessage("É necessário permitir o acesso à localização para utilizar esta funcionalidade."),
    "textNearbyNotificationTitle" : m2,
    "textMoreInformation" : MessageLookupByLibrary.simpleMessage("MAIS INFORMAÇÕES"),
    "textKmFromIncident" : m3
  };
}
