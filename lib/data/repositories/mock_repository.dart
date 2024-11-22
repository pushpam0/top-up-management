import 'package:top_up_management/data/models/beneficiary.dart';

class MockRepository {
  bool isVerified = false; // Toggle this to true for testing verified users
  double balance = 5000; // Initial balance
  List<Beneficiary> beneficiaries = [
    Beneficiary(id: "1", nickname: "John", mobileNumber: "+971501234567", monthlyTopUp: 0),
    Beneficiary(id: "2", nickname: "Doe", mobileNumber: "+971581234899", monthlyTopUp: 0),
  ];

  // Track the current month
  int currentMonth = DateTime.now().month;

  Future<List<Beneficiary>> fetchBeneficiaries() async {
    // Reset monthly limits if the month has changed
    _resetMonthlyLimitsIfNewMonth();
    return beneficiaries;
  }

  Future<bool> addBeneficiaryWithMobile(String nickname, String mobileNumber) async {
    _resetMonthlyLimitsIfNewMonth();
    if (beneficiaries.length >= 5) return false; // Max 5 beneficiaries
    beneficiaries.add(
      Beneficiary(
        id: DateTime.now().toString(),
        nickname: nickname,
        mobileNumber: mobileNumber,
        monthlyTopUp: 0,
      ),
    );
    return true;
  }

  Future<bool> topUp(String beneficiaryId, double amount) async {
    _resetMonthlyLimitsIfNewMonth();
    final beneficiary = beneficiaries.firstWhere((b) => b.id == beneficiaryId);

    // Verification logic
    double maxLimitPerBeneficiary = isVerified ? 1000 : 500;
    double maxTotalLimit = 3000;

    double totalTopUp = beneficiaries.fold(
        0, (sum, beneficiary) => sum + beneficiary.monthlyTopUp);

    // Check limits
    if (beneficiary.monthlyTopUp + amount > maxLimitPerBeneficiary ||
        totalTopUp + amount > maxTotalLimit) {
      return false; // Top-up denied
    }

    beneficiary.monthlyTopUp += amount;
    balance -= (amount + 3); // Deduct transaction fee
    return true;
  }

  // Reset monthly limits if a new calendar month starts
  void _resetMonthlyLimitsIfNewMonth() {
    final currentSystemMonth = DateTime.now().month;
    if (currentSystemMonth != currentMonth) {
      for (var beneficiary in beneficiaries) {
        beneficiary.monthlyTopUp = 0; // Reset the monthly top-up for all beneficiaries
      }
      currentMonth = currentSystemMonth; // Update the stored month
    }
  }

  /// Reset all data when the verification status is toggled
  void resetData() {
    // Reset balance and beneficiaries to default values
    balance = 5000;
    beneficiaries = [
      Beneficiary(id: "1", nickname: "John", mobileNumber: "9876543210", monthlyTopUp: 0),
      Beneficiary(id: "2", nickname: "Doe", mobileNumber: "8765432190", monthlyTopUp: 0),
    ];
    // Reset monthly limits
    _resetMonthlyLimitsIfNewMonth();
  }
}
