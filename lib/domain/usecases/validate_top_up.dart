class ValidateTopUp {
  bool call({
    required double balance,
    required double amount,
    required double monthlyLimit,
    required bool isVerified,
  }) {
    final maxLimit = isVerified ? 1000.0 : 500.0;
    return amount <= balance && (monthlyLimit + amount <= maxLimit);
  }
}
