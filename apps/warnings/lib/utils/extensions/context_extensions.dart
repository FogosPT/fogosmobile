import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
