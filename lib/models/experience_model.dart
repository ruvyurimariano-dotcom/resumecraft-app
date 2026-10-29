import 'package:uuid/uuid.dart';

class WorkExperience {
  final String id;
  final String jobTitle;
  final String company;
  final String location;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isCurrentlyWorking;
  final String description;
  final List<String> achievements;

  WorkExperience({
    String? id,
    this.jobTitle = '',
    this.company = '',
    this.location = '',
    this.startDate,
    this.endDate,
    this.isCurrentlyWorking = false,
    this.description = '',
    List<String>? achievements,
  })  : id = id ?? const Uuid().v4(),
        achievements = achievements ?? [];

  WorkExperience copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentlyWorking,
    String? description,
    List<String>? achievements,
  }) {
    return WorkExperience(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyWorking: isCurrentlyWorking ?? this.isCurrentlyWorking,
      description: description ?? this.description,
      achievements: achievements ?? List.from(this.achievements),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'company': company,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrentlyWorking': isCurrentlyWorking,
      'description': description,
      'achievements': achievements,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as String?,
      jobTitle: json['jobTitle'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      isCurrentlyWorking: json['isCurrentlyWorking'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
