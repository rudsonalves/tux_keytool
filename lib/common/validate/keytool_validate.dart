class KeyToolValidate {
  static String? commonNameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'The Common Name must not have at least 3 characters';
    }
    return null;
  }

  static String? passwordValidate(String? value) {
    final regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{12,}$');
    if (value == null || value.length < 12) {
      return 'The password must be at least 12 characters long';
    } else if (!regex.hasMatch(value)) {
      return 'Least 12 characters long including uppercase letters, lowercase letters, numbers and symbols';
    }
    return null;
  }

  static String? dirrectoryValidate(String? value) {
    if (value == null) {
      return 'keyStorage directory cannot be null';
    }
    return null;
  }
}
