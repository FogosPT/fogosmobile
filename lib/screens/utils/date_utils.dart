
import 'package:intl/intl.dart';

class FogosDateUtils {

  static String getDate(DateTime? time) {
    if (time == null) return '';
    String date = "${time.day}/${time.month}/${time.year}";
    String hours = DateFormat.Hm().format(time);
    return "$date - $hours";
  }
}

