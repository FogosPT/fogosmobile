import 'package:flutter/foundation.dart';

/// Email address for contact
const kContactEmail = 'mail@fogos.pt';

/// The interval in which the fires are refreshed in minutes int
const kRefreshTimeMinutes = 2;

/// The interval in which the fires are refreshed
const Duration kRefreshInterval = kDebugMode
    ? Duration(seconds: 10)
    : Duration(minutes: kRefreshTimeMinutes);
