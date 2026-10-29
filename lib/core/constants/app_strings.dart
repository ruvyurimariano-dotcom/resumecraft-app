/// Centralized string constants for ResumeCraft.
class AppStrings {
  AppStrings._();

  // App Meta
  static const String appName = 'ResumeCraft';
  static const String appTagline = 'Build a Resume. Build Your Future.';
  static const String appVersion = '1.0.0';

  // Onboarding
  static const String onbTitle1 = 'Create a Professional Resume';
  static const String onbDesc1 =
      'Build a polished resume in minutes using professionally designed, recruiter-tested templates.';
  static const String onbTitle2 = 'Customize Your Resume';
  static const String onbDesc2 =
      'Personalize colors, fonts, sections, and layouts that match your unique career story and style.';
  static const String onbTitle3 = 'Apply With Confidence';
  static const String onbDesc3 =
      'Export your resume as a clean, ATS-optimized PDF and share it with top employers worldwide.';

  // Builder Steps
  static const List<String> builderSteps = [
    'Personal',
    'Summary',
    'Experience',
    'Education',
    'Skills',
    'Projects',
    'Certifications',
    'Languages',
    'References',
    'Finish',
  ];

  // Resume Types
  static const String typeProfessional = 'Professional Resume';
  static const String typeStudent = 'Student Resume';
  static const String typeEntryLevel = 'Entry-Level Resume';
  static const String typeCreative = 'Creative Resume';
  static const String typeAcademic = 'Academic CV';
  static const String typeExecutive = 'Executive Resume';

  // Autosave Status
  static const String savedJustNow = 'Saved just now';
  static const String saving = 'Saving...';
  static const String saveFailed = 'Unable to save changes. Please try again.';

  // ATS Messages
  static const String atsCompatibility = 'ATS Compatibility';
  static const String improveResume = 'Improve Resume';

  // Export
  static const String exportTitle = 'Export Your Resume';
  static const String downloadPdf = 'Download PDF';
  static const String shareResume = 'Share Resume';
  static const String resumeReady = 'Your resume is ready!';
}
