import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/utils/network_utils.dart' as net;

/// Talks to the Fogos.pt backend that stores per-activity APNs push tokens
/// and forwards Live Activity updates. Only the fireId + push token + APNs
/// environment ever leave the device — never the user's location.
class LiveActivityBackend {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static Future<void> register({
    required String fireId,
    required String pushToken,
    required String env,
  }) async {
    final url = Endpoints.liveActivityRegisterUrl(fireId);
    try {
      final response = await net.post(url, data: {
        'pushToken': pushToken,
        'env': env,
      });
      final status = response?.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        _logger.e('LA register $status: ${response?.data}');
      }
    } on DioException catch (e) {
      _logger.e('LA register error: $e');
    }
  }

  static Future<void> unregister({
    required String fireId,
    required String pushToken,
  }) async {
    final url = Endpoints.liveActivityUnregisterUrl(fireId);
    try {
      final response = await net.post(url, data: {
        'pushToken': pushToken,
      });
      final status = response?.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        _logger.e('LA unregister $status: ${response?.data}');
      }
    } on DioException catch (e) {
      _logger.e('LA unregister error: $e');
    }
  }
}
