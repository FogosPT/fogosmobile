import 'package:fogospt/constants/variables.dart';
import 'package:sentry/sentry.dart';

final SentryClient sentry = SentryClient(SentryOptions(dsn: SENTRY_DSN));
