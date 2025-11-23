extension StringExtension on String {
  // Validation
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    ).hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^[0-9]{10,13}$').hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 6;
  }

  // String Manipulation
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // Number Formatting
  String get currencyFormat {
    final number = double.tryParse(this) ?? 0;
    return 'Rp ${number.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String orEmpty() => this ?? '';
  String orDefault(String defaultValue) => this ?? defaultValue;
}
