import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/endpoints.dart';

const int photoUploadMaxBytes = 20 * 1024 * 1024;

sealed class UploadResult {
  const UploadResult();
}

class UploadAccepted extends UploadResult {
  final String photoId;
  const UploadAccepted(this.photoId);
}

class UploadMissingGps extends UploadResult {
  const UploadMissingGps();
}

class UploadNotFound extends UploadResult {
  const UploadNotFound();
}

class UploadTooLarge extends UploadResult {
  const UploadTooLarge();
}

class UploadInvalidFormat extends UploadResult {
  const UploadInvalidFormat();
}

class UploadRateLimited extends UploadResult {
  final Duration retryAfter;
  const UploadRateLimited(this.retryAfter);
}

class UploadServerError extends UploadResult {
  const UploadServerError();
}

class UploadNetworkError extends UploadResult {
  const UploadNetworkError();
}

class IncidentPhotosService {
  IncidentPhotosService({Dio? dio}) : _dio = dio ?? _defaultDio();

  final Dio _dio;

  static Dio _defaultDio() => Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'User-Agent': 'FogosPT-App'},
        validateStatus: (_) => true,
      ));

  Future<UploadResult> uploadIncidentPhoto({
    required String fireId,
    required File photoFile,
    String? appVersion,
  }) async {
    if (!await photoFile.exists()) {
      return const UploadInvalidFormat();
    }
    final size = await photoFile.length();
    if (size > photoUploadMaxBytes) {
      return const UploadTooLarge();
    }

    final version = appVersion ?? await _appVersion();

    try {
      final form = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.uri.pathSegments.last,
        ),
      });

      final response = await _dio.post(
        Endpoints.incidentPhotoUploadUrl(fireId),
        data: form,
        options: Options(
          headers: {
            if (version != null) 'X-App-Version': version,
          },
          contentType: 'multipart/form-data',
        ),
      );

      return parseUploadResponse(
        statusCode: response.statusCode ?? 0,
        body: response.data,
        retryAfterHeader: response.headers.value('retry-after'),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return parseUploadResponse(
          statusCode: e.response!.statusCode ?? 0,
          body: e.response!.data,
          retryAfterHeader: e.response!.headers.value('retry-after'),
        );
      }
      return const UploadNetworkError();
    } catch (_) {
      return const UploadNetworkError();
    }
  }

  Future<String?> _appVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return null;
    }
  }
}

UploadResult parseUploadResponse({
  required int statusCode,
  required Object? body,
  String? retryAfterHeader,
}) {
  switch (statusCode) {
    case 202:
      final id = _extractPhotoId(body);
      return UploadAccepted(id ?? '');
    case 400:
      return const UploadInvalidFormat();
    case 404:
      return const UploadNotFound();
    case 413:
      return const UploadTooLarge();
    case 422:
      return const UploadMissingGps();
    case 429:
      return UploadRateLimited(_parseRetryAfter(retryAfterHeader));
    default:
      if (statusCode >= 500 && statusCode < 600) {
        return const UploadServerError();
      }
      return const UploadServerError();
  }
}

String? _extractPhotoId(Object? body) {
  if (body is Map) {
    final data = body['data'];
    if (data is Map && data['id'] is String) return data['id'] as String;
  }
  return null;
}

Duration _parseRetryAfter(String? header) {
  const fallback = Duration(seconds: 60);
  if (header == null) return fallback;
  final seconds = int.tryParse(header.trim());
  if (seconds != null && seconds > 0) return Duration(seconds: seconds);
  return fallback;
}
