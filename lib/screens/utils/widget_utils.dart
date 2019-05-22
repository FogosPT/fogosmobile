import 'dart:ui';

Color getFireColor(String fireStatus) {
  return Color(
    fireStatus == null ? 0xFF000000 : int.parse('0xFF$fireStatus'),
  );
}
