import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:top_up_management/core/utils/app_colors.dart';
import 'package:top_up_management/core/utils/app_text_styles.dart';
import 'package:top_up_management/core/utils/validation_utils.dart';
import 'package:top_up_management/data/repositories/mock_repository.dart';
import 'package:top_up_management/presentation/blocs/top_up_bloc.dart';
import 'package:top_up_management/presentation/blocs/top_up_event.dart';
import 'package:top_up_management/presentation/blocs/top_up_state.dart';
import 'package:top_up_management/presentation/widgets/error_modal.dart';

class HomePage extends StatelessWidget {
  final MockRepository repository;

  HomePage({required this.repository});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top-Up Manager", style: AppTextStyles.heading),
        backgroundColor: AppColors.primary,
        actions: [
          BlocBuilder<TopUpBloc, TopUpState>(
            builder: (context, state) {
              return Row(
                children: [
                  Text(
                    repository.isVerified ? "Verified" : "Unverified",
                    style: repository.isVerified
                        ? AppTextStyles.success
                        : AppTextStyles.error,
                  ),
                  Switch(
                    value: repository.isVerified,
                    onChanged: (value) {
                      BlocProvider.of<TopUpBloc>(context).add(ToggleVerification(value));
                    },
                    activeColor: AppColors.textPrimary,
                    activeTrackColor: AppColors.avatarBackground,
                    inactiveThumbColor: AppColors.error,
                    inactiveTrackColor: AppColors.errorAccent.withOpacity(0.5),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TopUpBloc, TopUpState>(
            listenWhen: (previous, current) =>
            current is TopUpLoaded && current.message != null,
            listener: (context, state) {
              if (state is TopUpLoaded && state.message != null) {
                ErrorModal.show(context, state.message!);
              }
            },
          ),
        ],
        child: BlocBuilder<TopUpBloc, TopUpState>(
          builder: (context, state) {
            if (state is TopUpLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopUpLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Balance: AED ${state.balance}",
                          style: AppTextStyles.secondryHeading,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Verification Status: ${repository.isVerified ? 'Verified' : 'Unverified'}",
                          style: repository.isVerified
                              ? AppTextStyles.successSecondry
                              : AppTextStyles.error,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.beneficiaries.length,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        final beneficiary = state.beneficiaries[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.success,
                              child: Icon(Icons.person, color: AppColors.primary),
                            ),
                            title: Text(
                              beneficiary.nickname,
                              style: AppTextStyles.name,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mobile: ${beneficiary.mobileNumber}",
                                    style: AppTextStyles.body,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "AED ${beneficiary.monthlyTopUp}",
                                    style: AppTextStyles.name,
                                  ),
                                ],
                              ),
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                _showTopUpDialog(context,
                                    BlocProvider.of<TopUpBloc>(context), beneficiary.id);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                backgroundColor: AppColors.avatarBackground,
                                foregroundColor: AppColors.success,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Top-Up",
                                style: AppTextStyles.heading,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showAddBeneficiaryDialog(
                              context, BlocProvider.of<TopUpBloc>(context));
                        },
                        icon: Icon(Icons.person_add, color: AppColors.textPrimary),
                        label: Text(
                          "Add Beneficiary",
                          style: AppTextStyles.heading,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 5,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is TopUpError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.error,
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  // Add Beneficiary Dialog
  void _showAddBeneficiaryDialog(BuildContext context, TopUpBloc topUpBloc) {
    final nicknameController = TextEditingController();
    String mobileNumberWithCountryCode = "+971"; // Default UAE country code
    bool isAddButtonEnabled = false;
    bool isPhoneNumberValid = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(16),
              title: Row(
                children: [
                  Icon(Icons.person_add, color: Colors.green, size: 30),
                  SizedBox(width: 8),
                  Text(
                    "Add Beneficiary",
                    style: AppTextStyles.secondryHeading,
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nickname Input
                  TextField(
                    controller: nicknameController,
                    decoration: InputDecoration(
                      labelText: "Nickname",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: nicknameController.text.trim().length > 20
                          ? "Nickname must not exceed 20 characters"
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        isAddButtonEnabled = _validateFields(
                          nicknameController.text.trim(),
                          mobileNumberWithCountryCode,
                        );
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  // Mobile Number Input
                  IntlPhoneField(
                    initialCountryCode: 'AE',
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: isPhoneNumberValid ? null : "Invalid UAE number format",
                    ),
                    onChanged: (phone) {
                      mobileNumberWithCountryCode = phone.completeNumber;
                      setState(() {
                        isPhoneNumberValid =
                            ValidationUtils.isValidUaeMobileNumber(mobileNumberWithCountryCode);
                        isAddButtonEnabled = _validateFields(
                          nicknameController.text.trim(),
                          mobileNumberWithCountryCode,
                        );
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Nickname must not exceed 20 characters.\nMobile number must be valid and in UAE format.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: isAddButtonEnabled
                      ? () {
                    final nickname = nicknameController.text.trim();
                    if (!ValidationUtils.isValidUaeMobileNumber(mobileNumberWithCountryCode)) {
                      ErrorModal.show(
                          context, "Please enter a valid UAE mobile number.");
                      return;
                    }
                    topUpBloc.add(AddBeneficiaryWithMobile(
                        nickname, mobileNumberWithCountryCode));
                    Navigator.of(context).pop();
                  }
                      : null, // Disable button if invalid
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAddButtonEnabled
                        ? Colors.green
                        : Colors.grey, // Disabled button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Helper for Validation
  bool _validateFields(String nickname, String mobileNumber) {
    return nickname.isNotEmpty &&
        nickname.length <= 20 &&
        ValidationUtils.isValidUaeMobileNumber(mobileNumber);
  }




  // Top-Up Dialog
  void _showTopUpDialog(BuildContext context, TopUpBloc topUpBloc, String beneficiaryId) {
    final topUpOptions = [5, 10, 20, 30, 50, 75, 100];
    double? selectedAmount;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          title: Row(
            children: [
              Icon(Icons.attach_money, color: Colors.green, size: 30),
              SizedBox(width: 8),
              Text(
                "Top-Up",
                style: AppTextStyles.secondryHeading,
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<double>(
                    decoration: InputDecoration(
                      labelText: "Select Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: topUpOptions.map((amount) {
                      return DropdownMenuItem(
                        value: amount.toDouble(),
                        child: Text("AED $amount"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAmount = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Transaction Fee: AED 3",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedAmount != null) {
                  topUpBloc.add(PerformTopUp(beneficiaryId, selectedAmount!));
                  Navigator.of(context).pop();
                }
              },
              child: Text("Top-Up", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
