import 'package:intl/intl.dart';

/// Date formatting utilities for resume timeframes.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _monthYear = DateFormat('MMM yyyy');
  static final DateFormat _yearOnly = DateFormat('yyyy');
  static final DateFormat _fullDate = DateFormat('MMMM d, yyyy');

  static String formatMonthYear(DateTime? date, {String fallback = 'Present'}) {
    if (date == null) return fallback;
    return _monthYear.format(date);
  }

  static String formatYear(DateTime? date, {String fallback = ''}) {
    if (date == null) return fallback;
    return _yearOnly.format(date);
  }

  static String formatFullDate(DateTime? date, {String fallback = ''}) {
    if (date == null) return fallback;
    return _fullDate.format(date);
  }

  static String formatRange(
    DateTime? start,
    DateTime? end, {
    bool isCurrent = false,
  }) {
    if (start == null) return '';
    final startStr = _monthYear.format(start);
    if (isCurrent) return '$startStr - Present';
    if (end == null) return startStr;
    return '$startStr - ${_monthYear.format(end)}';
  }

  static DateTime? parseDate(String? str) {
    if (str == null || str.trim().isEmpty) return null;
    try {
      return DateTime.parse(str);
    } catch (_) {
      return null;
    }
  }

  static String toIsoDateString(DateTime? date) {
    if (date == null) return '';
    return date.toIso8601String();
  }
}
