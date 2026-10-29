import 'package:flutter/material.dart';
import '../models/template_model.dart';

class TemplateService {
  static const List<ResumeTemplate> templates = [
    ResumeTemplate(
      id: 'modern_pro',
      name: 'Modern Pro',
      category: TemplateCategory.modern,
      isPremium: false,
      description: 'Sleek two-column header with balanced typography and clean section accents.',
      defaultPrimaryColor: Color(0xFF2563EB),
    ),
    ResumeTemplate(
      id: 'clean_ats',
      name: 'Clean ATS Standard',
      category: TemplateCategory.atsFriendly,
      isPremium: false,
      description: 'Optimized for high parser pass rates, standard single-column semantic layout.',
      defaultPrimaryColor: Color(0xFF1E3A8A),
    ),
    ResumeTemplate(
      id: 'executive_suite',
      name: 'Executive Suite',
      category: TemplateCategory.executive,
      isPremium: true,
      description: 'Sophisticated serif styling with dignified dark accents for leadership roles.',
      defaultPrimaryColor: Color(0xFF18181B),
    ),
    ResumeTemplate(
      id: 'minimal_slate',
      name: 'Minimal Slate',
      category: TemplateCategory.minimal,
      isPremium: false,
      description: 'Understated elegance with subtle dividers and maximum reading clarity.',
      defaultPrimaryColor: Color(0xFF475569),
    ),
    ResumeTemplate(
      id: 'creative_edge',
      name: 'Creative Edge',
      category: TemplateCategory.creative,
      isPremium: true,
      description: 'Vibrant sidebar layout perfect for designers, tech leads, and innovators.',
      defaultPrimaryColor: Color(0xFF059669),
    ),
    ResumeTemplate(
      id: 'student_starter',
      name: 'Campus Starter',
      category: TemplateCategory.student,
      isPremium: false,
      description: 'Structured layout emphasizing education, internships, projects, and skills.',
      defaultPrimaryColor: Color(0xFF2563EB),
    ),
    ResumeTemplate(
      id: 'corporate_elite',
      name: 'Corporate Elite',
      category: TemplateCategory.professional,
      isPremium: true,
      description: 'Timeless professional hierarchy favored by Fortune 500 recruiters.',
      defaultPrimaryColor: Color(0xFF991B1B),
    ),
  ];

  static List<ResumeTemplate> getTemplatesByCategory(TemplateCategory category) {
    if (category == TemplateCategory.all) return templates;
    return templates.where((t) => t.category == category).toList();
  }

  static ResumeTemplate getTemplateById(String id) {
    return templates.firstWhere(
      (t) => t.id == id,
      orElse: () => templates.first,
    );
  }
}
