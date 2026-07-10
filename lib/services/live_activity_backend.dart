import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Talks to the Fogos.pt backend that stores per-activity APNs push tokens
/// and forwards Live Activity updates. Only the fireId + push token + APNs
/// environment ever leave the device — never the user's location.
class LiveActivityBackend {
  static const _base = 'https://api.fogos.pt/v2/live-activity';
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static Future<void> register({
    required String fireId,
    required String pushToken,
    required String env,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_base/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fireId': fireId,
              'pushToken': pushToken,
              'env': env,
            }),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode >= 400) {
        _logger.w('LA register ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _logger.w('LA register error: $e');
    }
  }

  static Future<void> unregister({
    required String fireId,
    required String pushToken,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_base/unregister'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fireId': fireId,
              'pushToken': pushToken,
            }),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode >= 400) {
        _logger.w('LA unregister ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _logger.w('LA unregister error: $e');
    }
  }
}
