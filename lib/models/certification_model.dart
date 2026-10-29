import 'package:uuid/uuid.dart';

class Certification {
  final String id;
  final String certificationName;
  final String issuingOrganization;
  final DateTime? issueDate;
  final DateTime? expirationDate;
  final String credentialId;
  final String credentialUrl;

  Certification({
    String? id,
    this.certificationName = '',
    this.issuingOrganization = '',
    this.issueDate,
    this.expirationDate,
    this.credentialId = '',
    this.credentialUrl = '',
  }) : id = id ?? const Uuid().v4();

  Certification copyWith({
    String? id,
    String? certificationName,
    String? issuingOrganization,
    DateTime? issueDate,
    DateTime? expirationDate,
    String? credentialId,
    String? credentialUrl,
  }) {
    return Certification(
      id: id ?? this.id,
      certificationName: certificationName ?? this.certificationName,
      issuingOrganization: issuingOrganization ?? this.issuingOrganization,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificationName': certificationName,
      'issuingOrganization': issuingOrganization,
      'issueDate': issueDate?.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] as String?,
      certificationName: json['certificationName'] as String? ?? '',
      issuingOrganization: json['issuingOrganization'] as String? ?? '',
      issueDate: json['issueDate'] != null
          ? DateTime.tryParse(json['issueDate'] as String)
          : null,
      expirationDate: json['expirationDate'] != null
          ? DateTime.tryParse(json['expirationDate'] as String)
          : null,
      credentialId: json['credentialId'] as String? ?? '',
      credentialUrl: json['credentialUrl'] as String? ?? '',
    );
  }
}
