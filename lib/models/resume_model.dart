import 'package:uuid/uuid.dart';
import 'experience_model.dart';
import 'education_model.dart';
import 'skill_model.dart';
import 'project_model.dart';
import 'certification_model.dart';
import 'language_model.dart';
import 'reference_model.dart';
import 'template_model.dart';

class PersonalInfo {
  final String fullName;
  final String professionalTitle;
  final String profilePhoto;
  final String email;
  final String phone;
  final String location;
  final String website;
  final String linkedIn;
  final String portfolio;

  PersonalInfo({
    this.fullName = '',
    this.professionalTitle = '',
    this.profilePhoto = '',
    this.email = '',
    this.phone = '',
    this.location = '',
    this.website = '',
    this.linkedIn = '',
    this.portfolio = '',
  });

  PersonalInfo copyWith({
    String? fullName,
    String? professionalTitle,
    String? profilePhoto,
    String? email,
    String? phone,
    String? location,
    String? website,
    String? linkedIn,
    String? portfolio,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      professionalTitle: professionalTitle ?? this.professionalTitle,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      website: website ?? this.website,
      linkedIn: linkedIn ?? this.linkedIn,
      portfolio: portfolio ?? this.portfolio,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'professionalTitle': professionalTitle,
      'profilePhoto': profilePhoto,
      'email': email,
      'phone': phone,
      'location': location,
      'website': website,
      'linkedIn': linkedIn,
      'portfolio': portfolio,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['fullName'] as String? ?? '',
      professionalTitle: json['professionalTitle'] as String? ?? '',
      profilePhoto: json['profilePhoto'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      location: json['location'] as String? ?? '',
      website: json['website'] as String? ?? '',
      linkedIn: json['linkedIn'] as String? ?? '',
      portfolio: json['portfolio'] as String? ?? '',
    );
  }
}

class Resume {
  final String id;
  final String title;
  final String resumeType;
  final PersonalInfo personalInfo;
  final String summary;
  final List<WorkExperience> experiences;
  final List<Education> educations;
  final List<Skill> skills;
  final List<Project> projects;
  final List<Certification> certifications;
  final List<Language> languages;
  final List<Reference> references;
  final bool includeReferences;
  final CustomizationConfig customization;
  final DateTime createdAt;
  final DateTime updatedAt;

  Resume({
    String? id,
    this.title = 'My Resume',
    this.resumeType = 'Professional Resume',
    PersonalInfo? personalInfo,
    this.summary = '',
    List<WorkExperience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Project>? projects,
    List<Certification>? certifications,
    List<Language>? languages,
    List<Reference>? references,
    this.includeReferences = true,
    CustomizationConfig? customization,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        personalInfo = personalInfo ?? PersonalInfo(),
        experiences = experiences ?? [],
        educations = educations ?? [],
        skills = skills ?? [],
        projects = projects ?? [],
        certifications = certifications ?? [],
        languages = languages ?? [],
        references = references ?? [],
        customization = customization ?? CustomizationConfig(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  double get completionPercentage {
    double score = 0;
    // Personal Info (25%)
    if (personalInfo.fullName.trim().isNotEmpty) score += 0.08;
    if (personalInfo.email.trim().isNotEmpty) score += 0.07;
    if (personalInfo.phone.trim().isNotEmpty) score += 0.05;
    if (personalInfo.professionalTitle.trim().isNotEmpty) score += 0.05;

    // Summary (15%)
    if (summary.trim().isNotEmpty) score += 0.15;

    // Experience (20%)
    if (experiences.isNotEmpty) score += 0.20;

    // Education (15%)
    if (educations.isNotEmpty) score += 0.15;

    // Skills (10%)
    if (skills.isNotEmpty) score += 0.10;

    // Projects (5%)
    if (projects.isNotEmpty) score += 0.05;

    // Certifications or Languages (10%)
    if (certifications.isNotEmpty || languages.isNotEmpty) score += 0.10;

    return score.clamp(0.0, 1.0);
  }

  List<String> get missingSections {
    final list = <String>[];
    if (personalInfo.fullName.trim().isEmpty || personalInfo.email.trim().isEmpty) {
      list.add('Personal Info');
    }
    if (summary.trim().isEmpty) list.add('Professional Summary');
    if (experiences.isEmpty) list.add('Work Experience');
    if (educations.isEmpty) list.add('Education');
    if (skills.isEmpty) list.add('Skills');
    if (projects.isEmpty) list.add('Projects');
    return list;
  }

  Resume copyWith({
    String? id,
    String? title,
    String? resumeType,
    PersonalInfo? personalInfo,
    String? summary,
    List<WorkExperience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Project>? projects,
    List<Certification>? certifications,
    List<Language>? languages,
    List<Reference>? references,
    bool? includeReferences,
    CustomizationConfig? customization,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Resume(
      id: id ?? this.id,
      title: title ?? this.title,
      resumeType: resumeType ?? this.resumeType,
      personalInfo: personalInfo ?? this.personalInfo,
      summary: summary ?? this.summary,
      experiences: experiences ?? List.from(this.experiences),
      educations: educations ?? List.from(this.educations),
      skills: skills ?? List.from(this.skills),
      projects: projects ?? List.from(this.projects),
      certifications: certifications ?? List.from(this.certifications),
      languages: languages ?? List.from(this.languages),
      references: references ?? List.from(this.references),
      includeReferences: includeReferences ?? this.includeReferences,
      customization: customization ?? this.customization,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'resumeType': resumeType,
      'personalInfo': personalInfo.toJson(),
      'summary': summary,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'languages': languages.map((e) => e.toJson()).toList(),
      'references': references.map((e) => e.toJson()).toList(),
      'includeReferences': includeReferences,
      'customization': customization.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'My Resume',
      resumeType: json['resumeType'] as String? ?? 'Professional Resume',
      personalInfo: json['personalInfo'] != null
          ? PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>)
          : PersonalInfo(),
      summary: json['summary'] as String? ?? '',
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      educations: (json['educations'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => Language.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      references: (json['references'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      includeReferences: json['includeReferences'] as bool? ?? true,
      customization: json['customization'] != null
          ? CustomizationConfig.fromJson(
              json['customization'] as Map<String, dynamic>)
          : CustomizationConfig(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
