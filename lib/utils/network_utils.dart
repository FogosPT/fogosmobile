import 'package:dio/dio.dart';

const String _fptHeader = String.fromEnvironment('FPT_HEADER', defaultValue: '');

/// Headers every Fogos.pt HTTP request must carry. The `FPT` value is the
/// shared secret the backend uses to distinguish app traffic from generic
/// clients — without it Cloudflare rejects the request.
Map<String, String> commonHeaders() => {
      'User-Agent': 'FogosPT-App',
      'FPT': _fptHeader,
    };

/// Shared Dio instance for the standard 10s-timeout JSON traffic. Services
/// that need different timeouts (photo upload, etc.) should create their own
/// Dio but must still include [commonHeaders].
final Dio dio = Dio()
  ..options.connectTimeout = Duration(seconds: 10)
  ..options.receiveTimeout = Duration(seconds: 10)
  ..options.headers.addAll(commonHeaders());

Future<Response?> get(String path) async {
  try {
    final Response response = await dio.get(path);
    print('Request to $path performed with success (${response.statusCode}).');
    return response;
  } on DioException catch (e) {
    print(
        'Request to [$path] failed with error $e and headers [${e.response?.headers}].');
    return e.response;
  }
}

Future<Response?> post(String path, {Object? data}) async {
  try {
    final Response response = await dio.post(path, data: data);
    print('POST to $path performed with success (${response.statusCode}).');
    return response;
  } on DioException catch (e) {
    print(
        'POST to [$path] failed with error $e and headers [${e.response?.headers}].');
    return e.response;
  }
}
