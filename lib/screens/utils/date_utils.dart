
import 'package:intl/intl.dart';

class FogosDateUtils {

  static String getDate(DateTime time) {
    String date = "${time.day}/${time.month}/${time.year}";
    String hours = DateFormat.Hm().format(time);
    return "$date - $hours";
  }
}

