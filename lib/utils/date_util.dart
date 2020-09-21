import 'package:intl/intl.dart';

class DateUtil {

  static String formateYMD(DateTime dateTime){
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }
  static String formateYMDHMS_seconds(int milliseconds) {
    if(milliseconds == null){
      return "";
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }

  static String formateYMDHMS_string(String dateStr) {
    if(dateStr == null || dateStr.length == 0){
      return "";
    }
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }

  static String formateMDHM_seconds(int milliseconds) {
    if(milliseconds == null){
      return "";
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat("MM-dd HH:mm").format(dateTime);
  }

  static String formateMDHM_string(String dateStr) {
    if(dateStr == null || dateStr.length == 0){
      return "";
    }
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat("MM-dd HH:mm").format(dateTime);
  }
}
