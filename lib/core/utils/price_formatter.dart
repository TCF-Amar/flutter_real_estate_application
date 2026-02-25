class PriceFormatter {
  static String format(num value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toInt().toString()}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toInt().toString()}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toInt().toString()}K';
    } else {
      return value.toString();
    }
  }

  static String formatRange(String input) {
    if (input.isEmpty) return input;

    final parts = input.split(' - ');

    String formatSingle(String value) {
      try {
        final segments = value.split(' ');
        if (segments.length >= 2) {
          final currency = segments[0];
          final number = segments.sublist(1).join(' ').replaceAll(',', '');
          final price = double.parse(number);
          return '$currency ${_compact(price)}';
        }

        // Fallback: try to extract digits
        final digits = value.replaceAll(RegExp(r'[^0-9\.]'), '');
        if (digits.isEmpty) return value;
        final price = double.parse(digits);
        return _compact(price);
      } catch (_) {
        return value;
      }
    }

    if (parts.length < 2) return formatSingle(parts[0]);

    return '${formatSingle(parts[0])} - ${formatSingle(parts[1])}';
  }

  static String _compact(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toString();
    }
  }
}
