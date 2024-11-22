class TopUpEvent {}
class FetchBeneficiaries extends TopUpEvent {}
class AddBeneficiaryWithMobile extends TopUpEvent {
  final String nickname;
  final String mobileNumber;

  AddBeneficiaryWithMobile(this.nickname, this.mobileNumber);
}
class PerformTopUp extends TopUpEvent {
  final String beneficiaryId;
  final double amount;

  PerformTopUp(this.beneficiaryId, this.amount);
}
class ToggleVerification extends TopUpEvent {
  final bool isVerified;

  ToggleVerification(this.isVerified);
}