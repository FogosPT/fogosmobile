import 'package:flutter/services.dart';

Future<String> loadJsonFromAssets(String filePath) async {
  String jsonString = await rootBundle.loadString(filePath);
  return jsonString;
}
