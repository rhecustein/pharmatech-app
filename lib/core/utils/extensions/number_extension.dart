import 'package:intl/intl.dart';

extension IntExtension on int {
  String get currencyFormat {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

  String get compactFormat {
    if (this < 1000) return toString();
    if (this < 1000000) return '${(this / 1000).toStringAsFixed(1)}K';
    return '${(this / 1000000).toStringAsFixed(1)}M';
  }
}

extension DoubleExtension on double {
  String get currencyFormat {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

  String toCurrency({int decimalDigits = 0}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: decimalDigits,
    );
    return formatter.format(this);
  }

  String get compactFormat {
    if (this < 1000) return toStringAsFixed(0);
    if (this < 1000000) return '${(this / 1000).toStringAsFixed(1)}K';
    return '${(this / 1000000).toStringAsFixed(1)}M';
  }
}
