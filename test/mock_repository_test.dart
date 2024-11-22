import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_management/data/repositories/mock_repository.dart';

void main() {
  late MockRepository repository;

  setUp(() {
    repository = MockRepository()..isVerified = false;;
  });

  test("Fetch beneficiaries returns initial data", () async {
    final beneficiaries = await repository.fetchBeneficiaries();
    expect(beneficiaries.length, 2); // John and Doe
  });

  test("Add a beneficiary updates the list", () async {
    final success = await repository.addBeneficiaryWithMobile("Alice", "+971501234567");
    expect(success, true);
    expect(repository.beneficiaries.length, 3);
  });

  test("Cannot add more than 5 beneficiaries", () async {
    await repository.addBeneficiaryWithMobile("Alice1", "+971501234567");
    await repository.addBeneficiaryWithMobile("Alice2", "+971501234568");
    await repository.addBeneficiaryWithMobile("Alice3", "+971501234569");
    await repository.addBeneficiaryWithMobile("Alice4", "+971501234570");

    final success = await repository.addBeneficiaryWithMobile("Alice5", "+971501234571");
    expect(success, false); // Exceeds limit
  });

  test("Monthly top-up resets on new month", () async {
    repository.beneficiaries[0].monthlyTopUp = 500;
    repository.currentMonth = DateTime.now().month - 1; // Simulate last month

    await repository.fetchBeneficiaries();
    expect(repository.beneficiaries[0].monthlyTopUp, 0); // Should reset
  });

  test("Global top-up limit enforcement", () async {
    repository.isVerified = true;
    await repository.topUp("1", 1000); // Max for John
    await repository.topUp("2", 2000); // Attempt exceeding global limit

    expect(repository.beneficiaries[1].monthlyTopUp, 0); // Not updated due to limit
  });
}
