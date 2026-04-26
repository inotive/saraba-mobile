import 'package:intl/intl.dart';

class RequestDateParser {
  static DateTime? parse(String value) {
    if (value.isEmpty) return null;

    try {
      return DateFormat('dd/MM/yyyy').parseStrict(value);
    } catch (_) {
      return null;
    }
  }
}
