import 'package:intl/intl.dart';

String formatRupiah(num value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(value);
}

/// `2026-10-15` -> `15 Oktober 2026`; mengembalikan teks asli jika tidak bisa diparse.
String formatLongDate(String rawDate) {
  try {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}
