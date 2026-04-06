import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String toIDR(dynamic amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }
}
