import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';

class FogosLocalizationsDelegate
    extends LocalizationsDelegate<FogosLocalizations> {
  const FogosLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['pt', 'en'].contains(locale.languageCode);

  @override
  Future<FogosLocalizations> load(Locale locale) =>
      FogosLocalizations.load(locale);

  @override
  //todo: this must be changed if the app changes the language in runtime
  bool shouldReload(LocalizationsDelegate<FogosLocalizations> old) => false;
}
