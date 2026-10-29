import 'package:uuid/uuid.dart';

class Reference {
  final String id;
  final String name;
  final String jobTitle;
  final String company;
  final String email;
  final String phone;

  Reference({
    String? id,
    this.name = '',
    this.jobTitle = '',
    this.company = '',
    this.email = '',
    this.phone = '',
  }) : id = id ?? const Uuid().v4();

  Reference copyWith({
    String? id,
    String? name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
  }) {
    return Reference(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'jobTitle': jobTitle,
      'company': company,
      'email': email,
      'phone': phone,
    };
  }

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      company: json['company'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}
