import 'package:dio/dio.dart';

final Dio _dio = Dio();

Future<Response> get(String path) async {
  final Response response = await _dio.get(path);
  print('Request to $path performed with success (${response.statusCode}).');
  return response;
}
