import 'package:intl/intl.dart';

class DateTimeUtils {
  /// Formats a date string (ISO 8601) to "MMM yyyy" (e.g., "Dec 2024").
  /// Returns "N/A" if the input is null or invalid.
  static String formatMonthYear(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// Formats a date string (ISO 8601) to a full readable date.
  /// (e.g., "December 1, 2024")
  static String formatFullDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat.yMMMMd().format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// Safely parses a string to DateTime, returning null if invalid.
  static DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }
}
