import 'package:fogosmobile/constants/variables.dart';
import 'package:sentry/sentry.dart';

/// TODO(FB): Move SENTRY_DSN to lib/src/shared/constants.dart
final SentryClient sentry = SentryClient(SentryOptions(dsn: SENTRY_DSN));
