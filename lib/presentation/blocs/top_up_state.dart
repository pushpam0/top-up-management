import 'package:top_up_management/data/models/beneficiary.dart';

class TopUpState {}
class TopUpLoading extends TopUpState {}
class TopUpLoaded extends TopUpState {
  final List<Beneficiary> beneficiaries;
  final double balance;
  final String? message;

  TopUpLoaded(this.beneficiaries, this.balance, [this.message]);
}
class TopUpError extends TopUpState {
  final String message;

  TopUpError(this.message);
}