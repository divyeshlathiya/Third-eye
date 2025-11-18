// utils/validator.dart
class Validator {
  // Email validation method
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address';
    }

    if (trimmedEmail.contains(' ')) {
      return 'Email should not contain spaces';
    }

    if (trimmedEmail.length > 254) {
      return 'Email is too long';
    }

    return null;
  }

  // Password validation method
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    if (password.contains(' ')) {
      return 'Password should not contain spaces';
    }

    return null;
  }

  static bool isOtpValid(String otp) {
    if (otp.isEmpty) return false;
    if (otp.length != 6) return false;
    return RegExp(r'^[0-9]+$').hasMatch(otp);
  }

  // Name validation method
  static String? validateName(String? name, String fieldName) {
    if (name == null || name.isEmpty) {
      return '$fieldName is required';
    }

    if (name.length < 2) {
      return '$fieldName must be at least 2 characters long';
    }

    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(name)) {
      return '$fieldName should contain only letters';
    }

    return null;
  }
}
