class ValidationUtils {
  static bool isValidUaeMobileNumber(String mobileNumber) {
    // +971 followed by valid UAE number prefixes (50, 52, 54, etc.)
    final RegExp uaeMobileRegex = RegExp(r'^\+971(?:50|52|54|55|56|58|59)\d{7}$');
    return uaeMobileRegex.hasMatch(mobileNumber);
  }
}
