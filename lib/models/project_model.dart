import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String projectName;
  final String role;
  final String description;
  final List<String> technologies;
  final String projectUrl;
  final DateTime? startDate;
  final DateTime? endDate;

  Project({
    String? id,
    this.projectName = '',
    this.role = '',
    this.description = '',
    List<String>? technologies,
    this.projectUrl = '',
    this.startDate,
    this.endDate,
  })  : id = id ?? const Uuid().v4(),
        technologies = technologies ?? [];

  Project copyWith({
    String? id,
    String? projectName,
    String? role,
    String? description,
    List<String>? technologies,
    String? projectUrl,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Project(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      role: role ?? this.role,
      description: description ?? this.description,
      technologies: technologies ?? List.from(this.technologies),
      projectUrl: projectUrl ?? this.projectUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectName': projectName,
      'role': role,
      'description': description,
      'technologies': technologies,
      'projectUrl': projectUrl,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String?,
      projectName: json['projectName'] as String? ?? '',
      role: json['role'] as String? ?? '',
      description: json['description'] as String? ?? '',
      technologies: (json['technologies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      projectUrl: json['projectUrl'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
    );
  }
}
