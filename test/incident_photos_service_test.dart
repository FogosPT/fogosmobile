import 'package:flutter_test/flutter_test.dart';
import 'package:fogosmobile/services/incident_photos_service.dart';

void main() {
  group('parseUploadResponse', () {
    test('202 with body returns UploadAccepted with photoId', () {
      final result = parseUploadResponse(
        statusCode: 202,
        body: {
          'success': true,
          'data': {'id': 'abc123', 'status': 'pending'},
        },
      );
      expect(result, isA<UploadAccepted>());
      expect((result as UploadAccepted).photoId, 'abc123');
    });

    test('202 with no parsable body still returns UploadAccepted', () {
      final result = parseUploadResponse(statusCode: 202, body: null);
      expect(result, isA<UploadAccepted>());
    });

    test('400 returns UploadInvalidFormat', () {
      expect(parseUploadResponse(statusCode: 400, body: null),
          isA<UploadInvalidFormat>());
    });

    test('404 returns UploadNotFound', () {
      expect(parseUploadResponse(statusCode: 404, body: null),
          isA<UploadNotFound>());
    });

    test('413 returns UploadTooLarge', () {
      expect(parseUploadResponse(statusCode: 413, body: null),
          isA<UploadTooLarge>());
    });

    test('422 returns UploadMissingGps', () {
      expect(parseUploadResponse(statusCode: 422, body: null),
          isA<UploadMissingGps>());
    });

    test('429 with Retry-After parses seconds', () {
      final result = parseUploadResponse(
        statusCode: 429,
        body: null,
        retryAfterHeader: '90',
      );
      expect(result, isA<UploadRateLimited>());
      expect((result as UploadRateLimited).retryAfter,
          const Duration(seconds: 90));
    });

    test('429 without Retry-After uses fallback', () {
      final result = parseUploadResponse(statusCode: 429, body: null);
      expect(result, isA<UploadRateLimited>());
      expect((result as UploadRateLimited).retryAfter.inSeconds, greaterThan(0));
    });

    test('500 returns UploadServerError', () {
      expect(parseUploadResponse(statusCode: 500, body: null),
          isA<UploadServerError>());
    });

    test('503 returns UploadServerError', () {
      expect(parseUploadResponse(statusCode: 503, body: null),
          isA<UploadServerError>());
    });
  });
}
