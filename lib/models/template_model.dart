import 'package:flutter/material.dart';

enum TemplateCategory {
  all('All'),
  atsFriendly('ATS Friendly'),
  professional('Professional'),
  modern('Modern'),
  minimal('Minimal'),
  creative('Creative'),
  executive('Executive'),
  student('Student');

  final String label;
  const TemplateCategory(this.label);
}

enum ResumeLayout {
  oneColumn('One Column', 'Clean linear single-column format'),
  twoColumn('Two Column', 'Modern two-column layout with sidebar'),
  compact('Compact', 'High-density layout fitting more achievements'),
  spacious('Spacious', 'Airy, modern design with generous breathing room');

  final String label;
  final String description;
  const ResumeLayout(this.label, this.description);
}

class ResumeTemplate {
  final String id;
  final String name;
  final TemplateCategory category;
  final bool isPremium;
  final String description;
  final Color defaultPrimaryColor;
  final String thumbnailPlaceholder;

  const ResumeTemplate({
    required this.id,
    required this.name,
    required this.category,
    this.isPremium = false,
    required this.description,
    this.defaultPrimaryColor = const Color(0xFF2563EB),
    this.thumbnailPlaceholder = '',
  });
}

class CustomizationConfig {
  final String templateId;
  final String colorHex;
  final String fontFamily;
  final ResumeLayout layout;
  final double headingSize;
  final double bodySize;
  final double lineSpacing;
  final List<String> sectionOrder;
  final Map<String, bool> sectionVisibility;

  CustomizationConfig({
    this.templateId = 'modern_pro',
    this.colorHex = '#2563EB',
    this.fontFamily = 'Roboto',
    this.layout = ResumeLayout.twoColumn,
    this.headingSize = 18.0,
    this.bodySize = 11.0,
    this.lineSpacing = 1.3,
    List<String>? sectionOrder,
    Map<String, bool>? sectionVisibility,
  })  : sectionOrder = sectionOrder ??
            [
              'Summary',
              'Experience',
              'Education',
              'Skills',
              'Projects',
              'Certifications',
              'Languages',
              'References',
            ],
        sectionVisibility = sectionVisibility ??
            {
              'Summary': true,
              'Experience': true,
              'Education': true,
              'Skills': true,
              'Projects': true,
              'Certifications': true,
              'Languages': true,
              'References': true,
            };

  CustomizationConfig copyWith({
    String? templateId,
    String? colorHex,
    String? fontFamily,
    ResumeLayout? layout,
    double? headingSize,
    double? bodySize,
    double? lineSpacing,
    List<String>? sectionOrder,
    Map<String, bool>? sectionVisibility,
  }) {
    return CustomizationConfig(
      templateId: templateId ?? this.templateId,
      colorHex: colorHex ?? this.colorHex,
      fontFamily: fontFamily ?? this.fontFamily,
      layout: layout ?? this.layout,
      headingSize: headingSize ?? this.headingSize,
      bodySize: bodySize ?? this.bodySize,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      sectionOrder: sectionOrder ?? List.from(this.sectionOrder),
      sectionVisibility: sectionVisibility ?? Map.from(this.sectionVisibility),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templateId': templateId,
      'colorHex': colorHex,
      'fontFamily': fontFamily,
      'layout': layout.name,
      'headingSize': headingSize,
      'bodySize': bodySize,
      'lineSpacing': lineSpacing,
      'sectionOrder': sectionOrder,
      'sectionVisibility': sectionVisibility,
    };
  }

  factory CustomizationConfig.fromJson(Map<String, dynamic> json) {
    return CustomizationConfig(
      templateId: json['templateId'] as String? ?? 'modern_pro',
      colorHex: json['colorHex'] as String? ?? '#2563EB',
      fontFamily: json['fontFamily'] as String? ?? 'Roboto',
      layout: ResumeLayout.values.firstWhere(
        (e) => e.name == json['layout'],
        orElse: () => ResumeLayout.twoColumn,
      ),
      headingSize: (json['headingSize'] as num?)?.toDouble() ?? 18.0,
      bodySize: (json['bodySize'] as num?)?.toDouble() ?? 11.0,
      lineSpacing: (json['lineSpacing'] as num?)?.toDouble() ?? 1.3,
      sectionOrder: (json['sectionOrder'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [
            'Summary',
            'Experience',
            'Education',
            'Skills',
            'Projects',
            'Certifications',
            'Languages',
            'References',
          ],
      sectionVisibility: (json['sectionVisibility'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as bool)) ??
          {
            'Summary': true,
            'Experience': true,
            'Education': true,
            'Skills': true,
            'Projects': true,
            'Certifications': true,
            'Languages': true,
            'References': true,
          },
    );
  }
}
