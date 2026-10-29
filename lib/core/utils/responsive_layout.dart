import 'package:flutter/material.dart';

/// Responsive helper for Android screen sizes (Compact phone, Medium phone, Large/Tablet).
class ResponsiveLayout {
  ResponsiveLayout._();

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 32.0;
    if (width < 360) return 12.0;
    return 16.0;
  }

  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 720) return 680.0;
    return double.infinity;
  }
}
