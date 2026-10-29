import 'package:uuid/uuid.dart';

class Education {
  final String id;
  final String degree;
  final String institution;
  final String location;
  final DateTime? startDate;
  final DateTime? graduationDate;
  final String gpa;
  final String description;

  Education({
    String? id,
    this.degree = '',
    this.institution = '',
    this.location = '',
    this.startDate,
    this.graduationDate,
    this.gpa = '',
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  Education copyWith({
    String? id,
    String? degree,
    String? institution,
    String? location,
    DateTime? startDate,
    DateTime? graduationDate,
    String? gpa,
    String? description,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      graduationDate: graduationDate ?? this.graduationDate,
      gpa: gpa ?? this.gpa,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'institution': institution,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'graduationDate': graduationDate?.toIso8601String(),
      'gpa': gpa,
      'description': description,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as String?,
      degree: json['degree'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      graduationDate: json['graduationDate'] != null
          ? DateTime.tryParse(json['graduationDate'] as String)
          : null,
      gpa: json['gpa'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
