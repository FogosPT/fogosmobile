import 'package:flutter/material.dart' show BuildContext;
import 'package:fogospt/l10n/app_localizations.dart' show AppLocalizations;

extension ContextExtensions on BuildContext {
  /// Returns the localized strings for the FOGOS.pt application.
  AppLocalizations get l10n_fogos => AppLocalizations.of(this)!;
}
