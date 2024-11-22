import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_management/data/repositories/mock_repository.dart';
import 'package:top_up_management/presentation/blocs/top_up_bloc.dart';
import 'package:top_up_management/presentation/blocs/top_up_event.dart';
import 'package:top_up_management/presentation/blocs/top_up_state.dart';

void main() {
  late MockRepository repository;
  late TopUpBloc bloc;

  setUp(() {
    repository = MockRepository();
    bloc = TopUpBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });

  group("TopUpBloc Tests", () {
    test("Initial state is TopUpLoading", () {
      expect(bloc.state, isA<TopUpLoading>());
    });

    blocTest<TopUpBloc, TopUpState>(
      "Fetch beneficiaries successfully",
      build: () => bloc,
      act: (bloc) => bloc.add(FetchBeneficiaries()),
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) => state.beneficiaries.length,
          "Initial beneficiaries",
          2, // John and Doe in MockRepository
        ),
      ],
    );

    blocTest<TopUpBloc, TopUpState>(
      "Add a beneficiary with valid data",
      build: () => bloc,
      act: (bloc) =>
          bloc.add(AddBeneficiaryWithMobile("Alice", "+971501234567")),
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) => state.beneficiaries.length,
          "New beneficiaries",
          3, // Two initial + one added
        ),
      ],
    );

    blocTest<TopUpBloc, TopUpState>(
      "Add a beneficiary with invalid nickname",
      build: () => bloc,
      act: (bloc) => bloc.add(
        AddBeneficiaryWithMobile(
            "A very long nickname exceeding 20 chars", "+971501234567"),
      ),
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) => state.message,
          "Error message",
          "Nickname must not exceed 20 characters.",
        ),
      ],
    );

    blocTest<TopUpBloc, TopUpState>(
      "Add a beneficiary with invalid mobile number",
      build: () => bloc,
      act: (bloc) =>
          bloc.add(AddBeneficiaryWithMobile("Alice", "+971123456")), // Invalid
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) => state.message,
          "Error message",
          "Please enter a valid UAE mobile number (e.g., +971501234567).",
        ),
      ],
    );

    blocTest<TopUpBloc, TopUpState>(
      "Perform a valid top-up",
      build: () => bloc,
      act: (bloc) => bloc.add(PerformTopUp("1", 50)), // Top up John with AED 50
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) =>
          state.beneficiaries.firstWhere((b) => b.id == "1").monthlyTopUp,
          "Updated monthly top-up",
          50, // Top-up amount
        ),
      ],
    );

    blocTest<TopUpBloc, TopUpState>(
      "Perform a top-up exceeding the per-beneficiary limit for unverified users",
      build: () => bloc,
      setUp: () {
        repository.isVerified = false; // Unverified user
        repository.beneficiaries[0].monthlyTopUp = 500; // Max limit reached
      },
      act: (bloc) => bloc.add(PerformTopUp("1", 100)), // Attempt exceeding limit
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) => state.message,
          "Error message",
          "Unverified users cannot top up more than AED 500 per beneficiary per calendar month.",
        ),
      ],
    );

    blocTest<TopUpBloc, TopUpState>(
      "Perform a top-up exceeding the global monthly limit",
      build: () => bloc,
      setUp: () {
        repository.isVerified = true; // Verified user
        repository.beneficiaries[0].monthlyTopUp = 1000; // Max limit reached
        repository.beneficiaries[1].monthlyTopUp = 2000; // Close to global max
      },
      act: (bloc) => bloc.add(PerformTopUp("2", 500)), // Exceed global limit
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) => state.message,
          "Error message",
          "Top-ups cannot exceed AED 3,000 per calendar month for all beneficiaries.",
        ),
      ],
    );

    blocTest<TopUpBloc, TopUpState>(
      "Perform a top-up exceeding only the per-beneficiary limit for verified users",
      build: () => bloc,
      setUp: () {
        repository.isVerified = true; // Verified user
        repository.beneficiaries[0].monthlyTopUp = 1000; // Max limit reached
      },
      act: (bloc) => bloc.add(PerformTopUp("1", 100)), // Exceed per-beneficiary limit
      expect: () => [
        isA<TopUpLoaded>().having(
              (state) => state.message,
          "Error message",
          "Verified users cannot top up more than AED 1,000 per beneficiary per calendar month.",
        ),
      ],
    );
  });
}
