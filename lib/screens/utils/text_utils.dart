import 'package:diacritic/diacritic.dart';

String transformStringToSearch(String search) {
  return removeDiacritics(search.toLowerCase());
}
