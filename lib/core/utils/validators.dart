/// Comprehensive form validation rules for ResumeCraft.
class Validators {
  Validators._();

  static String? requiredField(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional unless required
    }
    final phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)]{7,20}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    final trimmed = value.trim();
    if (!trimmed.startsWith('http://') &&
        !trimmed.startsWith('https://') &&
        !trimmed.startsWith('www.')) {
      return 'Please enter a valid URL (e.g. https://linkedin.com/in/...)';
    }
    return null;
  }

  static String? gpa(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final numVal = double.tryParse(value.trim());
    if (numVal == null || numVal < 0 || numVal > 10.0) {
      return 'Enter a valid GPA (e.g. 3.8 or 9.2)';
    }
    return null;
  }
}
