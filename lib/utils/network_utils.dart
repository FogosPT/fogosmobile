import 'package:dio/dio.dart';

const String _fptHeader = String.fromEnvironment('FPT_HEADER', defaultValue: '');

final Dio _dio = Dio()
  ..options.connectTimeout = Duration(seconds: 10)
  ..options.receiveTimeout = Duration(seconds: 10)
  ..options.headers['User-Agent'] = 'FogosPT-App'
  ..options.headers['FPT'] = _fptHeader;

Future<Response?> get(String path) async {
  try {
    final Response response = await _dio.get(path);
    print('Request to $path performed with success (${response.statusCode}).');
    return response;
  } on DioException catch (e) {
    print(
        'Request to [$path] failed with error $e and headers [${e.response?.headers}].');
    return e.response;
  }
}
