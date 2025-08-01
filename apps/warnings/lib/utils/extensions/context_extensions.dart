import 'package:flutter/material.dart';
import 'package:warnings/l10n/app_localizations.dart' as l10n_warnings;
extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  l10n_warnings.AppLocalizations get l10nWarnings =>
      l10n_warnings.AppLocalizations.of(this)!;
}
