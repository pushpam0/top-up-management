import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_up_management/core/utils/validation_utils.dart';
import 'package:top_up_management/presentation/blocs/top_up_event.dart';
import 'package:top_up_management/presentation/blocs/top_up_state.dart';
import '../../data/models/beneficiary.dart';
import '../../data/repositories/mock_repository.dart';


class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  final MockRepository repository;

  TopUpBloc(this.repository) : super(TopUpLoading()) {
    // Fetch Beneficiaries
    on<FetchBeneficiaries>((event, emit) async {
      try {
        final beneficiaries = await repository.fetchBeneficiaries();
        emit(TopUpLoaded(beneficiaries, repository.balance));
      } catch (e) {
        emit(TopUpError("Failed to load beneficiaries"));
      }
    });

    // Add Beneficiary with Mobile Number
    on<AddBeneficiaryWithMobile>((event, emit) async {
      // Validate nickname length
      if (event.nickname.length > 20) {
        emit(TopUpLoaded(
          repository.beneficiaries,
          repository.balance,
          "Nickname must not exceed 20 characters.",
        ));
        return;
      }

      // Validate mobile number
      if (!ValidationUtils.isValidUaeMobileNumber(event.mobileNumber)) {
        emit(TopUpLoaded(
          repository.beneficiaries,
          repository.balance,
          "Please enter a valid UAE mobile number (e.g., +971501234567).",
        ));
        return;
      }

      // Attempt to add the beneficiary
      final success = await repository.addBeneficiaryWithMobile(event.nickname, event.mobileNumber);
      if (!success) {
        emit(TopUpLoaded(
          repository.beneficiaries,
          repository.balance,
          "Cannot add more than 5 beneficiaries.",
        ));
      } else {
        add(FetchBeneficiaries());
      }
    });

    // Perform Top-Up
    on<PerformTopUp>((event, emit) async {
      repository.fetchBeneficiaries(); // Ensure monthly limits are updated before processing

      final beneficiary = repository.beneficiaries.firstWhere((b) => b.id == event.beneficiaryId);

      final totalBeneficiaryTopUp = beneficiary.monthlyTopUp + event.amount;
      final totalGlobalTopUp = repository.beneficiaries.fold(0.0, (sum, b) => sum + b.monthlyTopUp) + event.amount;

      // Initialize error message
      String? errorMessage;

      // 1. Global Monthly Limit Check (prioritized)
      if (totalGlobalTopUp > 3000) {
        errorMessage = "Top-ups cannot exceed AED 3,000 per calendar month for all beneficiaries.";
      }

      // 2. Per-Beneficiary Limit Check
      if (errorMessage == null) {
        if (repository.isVerified) {
          if (totalBeneficiaryTopUp > 1000) {
            errorMessage =
            "Verified users cannot top up more than AED 1,000 per beneficiary per calendar month.";
          }
        } else {
          if (totalBeneficiaryTopUp > 500) {
            errorMessage =
            "Unverified users cannot top up more than AED 500 per beneficiary per calendar month.";
          }
        }
      }

      // 3. Balance Check
      final amountWithFee = event.amount + 3;
      if (errorMessage == null && repository.balance < amountWithFee) {
        errorMessage = "Insufficient balance. Ensure your balance covers the top-up and transaction fee.";
      }

      // Emit error message if found
      if (errorMessage != null) {
        emit(TopUpLoaded(
          repository.beneficiaries,
          repository.balance,
          errorMessage,
        ));
        return;
      }

      // Perform Top-Up
      final success = await repository.topUp(event.beneficiaryId, event.amount);
      if (!success) {
        emit(TopUpLoaded(
          repository.beneficiaries,
          repository.balance,
          "Top-up failed. Please try again.",
        ));
      } else {
        add(FetchBeneficiaries());
      }
    });

    on<ToggleVerification>((event, emit) async {
      repository.isVerified = event.isVerified;
      repository.resetData(); // Reset data
      add(FetchBeneficiaries()); // Refresh beneficiaries
    });
  }
}
