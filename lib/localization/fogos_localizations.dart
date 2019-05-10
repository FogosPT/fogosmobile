import 'dart:async';

import 'package:flutter/material.dart';
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
  /// Initialize localization systems and messages
  static Future<FogosLocalizations> load(Locale locale) async {
    // If we're given "en_US", we'll use it as-is. If we're
    // given "en", we extract it and use it.
    final String localeName =
        locale.countryCode == null || locale.countryCode.isEmpty
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

  // Localized Messages
  String get appTitle => Intl.message(
        "Fogos.pt",
        name: 'appTitle',
        desc: 'App title',
      );

  String get textNotifications => Intl.message(
        "Notificações",
        name: 'textNotifications',
        desc: 'Texto de notificações - App Drawer',
      );

  String get textCounty => Intl.message(
        "Concelho",
        name: 'textCounty',
        desc: 'County Text - List of Counties',
      );

  String get textEmptyNotifications => Intl.message(
        "Não tem notificações ativas para fogos",
        name: 'textEmptyNotifications',
        desc: 'Empty Notifications Text',
      );

  String get textStatus => Intl.message(
        "Estado",
        name: 'textStatus',
        desc: 'Status label',
      );

  String get textHumanMeans => Intl.message(
        "Meios humanos",
        name: 'textHumanMeans',
        desc: 'Human means label',
      );

  String get textTerrainMeans => Intl.message(
        "Meios terrestres",
        name: 'textTerrainMeans',
        desc: 'Terrain means label',
      );

  String get textAerealMeans => Intl.message(
        "Meios aéreos",
        name: 'textAerealMeans',
        desc: 'Aereal Means label',
      );

  /// Retrieve localization resources for the widget tree
  /// corresponding to the given `context`
  static FogosLocalizations of(BuildContext context) =>
      Localizations.of<FogosLocalizations>(context, FogosLocalizations);
}
