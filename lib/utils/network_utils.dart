import 'package:dio/dio.dart';

final Dio _dio = Dio()
  ..options.connectTimeout = 10000
  ..options.receiveTimeout = 10000;

Future<Response> get(String path) async {
  try {
    final Response response = await _dio.get(path);
    print('Request to $path performed with success (${response?.statusCode}).');
    return response;
  } on DioError catch (e) {
    print(
        'Request to [$path] failed with error $e and headers [${e?.response?.headers}].');
    return e?.response;
  }
}
