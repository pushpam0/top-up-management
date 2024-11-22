import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_management/core/utils/validation_utils.dart';

void main() {
  group("ValidationUtils.isValidUaeMobileNumber", () {
    test("Valid UAE number", () {
      expect(ValidationUtils.isValidUaeMobileNumber("+971501234567"), true);
    });

    test("Invalid UAE prefix", () {
      expect(ValidationUtils.isValidUaeMobileNumber("+971201234567"), false);
    });

    test("Incorrect length", () {
      expect(ValidationUtils.isValidUaeMobileNumber("+97150123"), false);
    });

    test("Empty number", () {
      expect(ValidationUtils.isValidUaeMobileNumber(""), false);
    });
  });
}
