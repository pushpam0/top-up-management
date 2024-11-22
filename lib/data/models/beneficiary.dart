class Beneficiary {
  final String id;
  final String nickname;
  final String mobileNumber; // Add mobile number
  double monthlyTopUp; // Remove `final` to make it mutable

  Beneficiary({
    required this.id,
    required this.nickname,
    required this.mobileNumber, // Add this parameter
    required this.monthlyTopUp,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'],
      nickname: json['nickname'],
      mobileNumber: json['mobileNumber'], // Deserialize mobile number
      monthlyTopUp: json['monthlyTopUp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'mobileNumber': mobileNumber, // Serialize mobile number
      'monthlyTopUp': monthlyTopUp,
    };
  }
}
