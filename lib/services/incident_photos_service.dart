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

class IncidentPhoto {
  final String id;
  final String url;
  final DateTime? capturedAt;
  final int? width;
  final int? height;

  const IncidentPhoto({
    required this.id,
    required this.url,
    this.capturedAt,
    this.width,
    this.height,
  });

  static IncidentPhoto? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final url = json['url'];
    if (id is! String || url is! String || url.isEmpty) return null;
    DateTime? captured;
    final rawCaptured = json['captured_at'] ?? json['taken_at'];
    if (rawCaptured is String) {
      captured = DateTime.tryParse(rawCaptured);
    }
    final width = json['width'];
    final height = json['height'];
    return IncidentPhoto(
      id: id,
      url: url,
      capturedAt: captured,
      width: width is int ? width : (width is num ? width.toInt() : null),
      height: height is int ? height : (height is num ? height.toInt() : null),
    );
  }
}

class IncidentPhotosPage {
  final List<IncidentPhoto> photos;
  final int total;
  final int page;
  final int perPage;

  const IncidentPhotosPage({
    required this.photos,
    required this.total,
    required this.page,
    required this.perPage,
  });

  bool get hasMore => page * perPage < total;
}

class IncidentPhotosService {
  IncidentPhotosService({Dio? dio}) : _dio = dio ?? _defaultDio();

  final Dio _dio;

  Future<IncidentPhotosPage?> fetchIncidentPhotos({
    required String fireId,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final url = Endpoints.incidentPhotosListUrl(
        fireId,
        page: page,
        perPage: perPage,
      );
      final response = await _dio.get(url);
      if (response.statusCode != 200) return null;
      final body = response.data;
      if (body is! Map) return null;
      final data = body['data'];
      if (data is! List) return null;
      final photos = <IncidentPhoto>[];
      for (final item in data) {
        final photo = IncidentPhoto.fromJson(item);
        if (photo != null) photos.add(photo);
      }
      final meta = body['meta'];
      int total = photos.length;
      int respPage = page;
      int respPerPage = perPage;
      if (meta is Map) {
        final t = meta['total'];
        if (t is int) total = t;
        else if (t is num) total = t.toInt();
        final p = meta['page'];
        if (p is int) respPage = p;
        final pp = meta['per_page'];
        if (pp is int) respPerPage = pp;
      }
      return IncidentPhotosPage(
        photos: photos,
        total: total,
        page: respPage,
        perPage: respPerPage,
      );
    } catch (e) {
      print('[incident_photo] fetch error: $e');
      return null;
    }
  }

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
    bool allowPublic = true,
    String? signature,
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
      final trimmedSignature = signature?.trim();
      final hasSignature =
          trimmedSignature != null && trimmedSignature.isNotEmpty;

      final form = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.uri.pathSegments.last,
        ),
        'public': allowPublic ? '1' : '0',
        if (hasSignature) 'signature': trimmedSignature,
      });

      final url = Endpoints.incidentPhotoUploadUrl(fireId);
      print('[incident_photo] POST $url (size=$size, version=$version, '
          'public=${allowPublic ? '1' : '0'}, '
          'signature=${hasSignature ? '"$trimmedSignature"' : '<none>'})');

      final response = await _dio.post(
        url,
        data: form,
        options: Options(
          headers: {
            if (version != null) 'X-App-Version': version,
          },
          contentType: 'multipart/form-data',
        ),
      );

      print('[incident_photo] response status=${response.statusCode} '
          'headers=${response.headers.map} body=${response.data}');

      return parseUploadResponse(
        statusCode: response.statusCode ?? 0,
        body: response.data,
        retryAfterHeader: response.headers.value('retry-after'),
      );
    } on DioException catch (e) {
      print('[incident_photo] DioException type=${e.type} message=${e.message} '
          'status=${e.response?.statusCode} body=${e.response?.data}');
      if (e.response != null) {
        return parseUploadResponse(
          statusCode: e.response!.statusCode ?? 0,
          body: e.response!.data,
          retryAfterHeader: e.response!.headers.value('retry-after'),
        );
      }
      return const UploadNetworkError();
    } catch (e, st) {
      print('[incident_photo] unexpected error: $e\n$st');
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
