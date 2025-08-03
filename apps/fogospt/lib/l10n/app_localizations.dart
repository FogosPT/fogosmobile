import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @fogospt.
  ///
  /// In pt, this message translates to:
  /// **'Fogos.pt'**
  String get fogospt;

  /// No description provided for @fires_map_page_notifications.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get fires_map_page_notifications;

  /// No description provided for @fires_map_page_notifications_list_municipalities.
  ///
  /// In pt, this message translates to:
  /// **'Notificações por Concelho'**
  String get fires_map_page_notifications_list_municipalities;

  /// No description provided for @fires_map_page_error.
  ///
  /// In pt, this message translates to:
  /// **'Notifications'**
  String get fires_map_page_error;

  /// No description provided for @fires_map_page_more_informations.
  ///
  /// In pt, this message translates to:
  /// **'mais informações'**
  String get fires_map_page_more_informations;

  /// No description provided for @fires_map_page_local.
  ///
  /// In pt, this message translates to:
  /// **'local'**
  String get fires_map_page_local;

  /// No description provided for @fires_map_page_state.
  ///
  /// In pt, this message translates to:
  /// **'estado'**
  String get fires_map_page_state;

  /// No description provided for @fires_map_page_nature.
  ///
  /// In pt, this message translates to:
  /// **'natureza'**
  String get fires_map_page_nature;

  /// No description provided for @fires_map_page_meteo.
  ///
  /// In pt, this message translates to:
  /// **'meteo'**
  String get fires_map_page_meteo;

  /// No description provided for @fires_map_page_share.
  ///
  /// In pt, this message translates to:
  /// **'partilhar'**
  String get fires_map_page_share;

  /// No description provided for @fires_map_page_risk_of_fire.
  ///
  /// In pt, this message translates to:
  /// **'risco de incêndio'**
  String get fires_map_page_risk_of_fire;

  /// No description provided for @fires_map_page_means_of_transportation.
  ///
  /// In pt, this message translates to:
  /// **'meios'**
  String get fires_map_page_means_of_transportation;

  /// No description provided for @fires_map_page_start.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get fires_map_page_start;

  /// No description provided for @partners_page_title.
  ///
  /// In pt, this message translates to:
  /// **'Parceiros'**
  String get partners_page_title;

  /// No description provided for @fire_detail_means.
  ///
  /// In pt, this message translates to:
  /// **'meios'**
  String get fire_detail_means;

  /// No description provided for @select_notifications_per_municipality.
  ///
  /// In pt, this message translates to:
  /// **'Notificações por Concelho'**
  String get select_notifications_per_municipality;

  /// No description provided for @select_notifications_per_municipality_error.
  ///
  /// In pt, this message translates to:
  /// **'Falhou o descarregar da informação do Concelho'**
  String get select_notifications_per_municipality_error;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
