import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en',
    ).format(number);
    return formattedNumber;
  }
}

class DateFormats {
  static String formatDate(DateTime date) {
    // Formatear la fecha usando el idioma español
    final formattedDate = DateFormat('EEEE d', 'es_ES').format(date);
    // Convertir la primera letra a mayúscula
    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }
}
