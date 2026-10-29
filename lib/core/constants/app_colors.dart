import 'package:flutter/material.dart';

/// Centralized color definitions following Material 3 guidelines and ResumeCraft design specs.
class AppColors {
  AppColors._();

  // Brand Primary & Accents
  static const Color primary = Color(0xFF2563EB); // Royal Indigo/Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimaryContainer = Color(0xFF1E3A8A);

  static const Color secondary = Color(0xFF4F46E5);
  static const Color secondaryContainer = Color(0xFFE0E7FF);
  static const Color onSecondaryContainer = Color(0xFF312E81);

  // Light Theme Surfaces & Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color outlineLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFE2E8F0);

  // Dark Theme Surfaces & Backgrounds
  static const Color backgroundDark = Color(0xFF090D16);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceVariantDark = Color(0xFF1F2937);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color outlineDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF334155);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  // Feedback & Status Colors
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoContainer = Color(0xFFE0F2FE);

  // Resume Template Palettes
  static const Color paletteBlue = Color(0xFF2563EB);
  static const Color paletteNavy = Color(0xFF1E3A8A);
  static const Color paletteBlack = Color(0xFF18181B);
  static const Color paletteGray = Color(0xFF475569);
  static const Color paletteGreen = Color(0xFF059669);
  static const Color paletteBurgundy = Color(0xFF991B1B);

  static const List<Map<String, dynamic>> resumePalettes = [
    {'name': 'Royal Blue', 'color': paletteBlue, 'hex': '#2563EB'},
    {'name': 'Executive Navy', 'color': paletteNavy, 'hex': '#1E3A8A'},
    {'name': 'Classic Noir', 'color': paletteBlack, 'hex': '#18181B'},
    {'name': 'Slate Gray', 'color': paletteGray, 'hex': '#475569'},
    {'name': 'Emerald Green', 'color': paletteGreen, 'hex': '#059669'},
    {'name': 'Burgundy Wine', 'color': paletteBurgundy, 'hex': '#991B1B'},
  ];
}
