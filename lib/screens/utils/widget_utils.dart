import 'dart:ui';

import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/assets/icons.dart';

Color getFireColor(Fire fire) {
  String fireStatus = fire.statusColor;

  if (fire.important == true) {
    fireStatus = 'FF0000';
  }

  return Color(
    fireStatus == null ? 0xFF000000 : int.parse('0xFF$fireStatus'),
  );
}

String getCorrectStatusImage(int statusId, bool important) {
  var status = "status-";
  if (important) {
    status = status + "important";
  } else {
    status = status + statusId.toString();
  }
  switch (status) {
    case "status-important":
    case "status-5":
    case "status-7":
    case "status-99":
    case "status-8":
      return imgSvgIconFire;
    case "status-3":
    case "status-4":
      return imgSvgIconAlarm;
    case "status-9":
      return imgSvgIconWatch;
    case "status-6":
    case "status-10":
      return imgSvgIconPointer;
    case "status-11":
    case "status-12":
      return imgSvgIconFake;
    default:
      return imgSvgIconFire;
  }
}
